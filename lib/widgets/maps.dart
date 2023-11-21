import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_taxi_tigui/assistance/assistanceMethode.dart';
import 'package:flutter_taxi_tigui/assistance/geofire_assistance.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/infoHandler/app_info.dart';
import 'package:flutter_taxi_tigui/models/active_nearby_availablewhen_driver.dart';
import 'package:flutter_taxi_tigui/pages/PreciserDepart.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/formAdresse.dart';
import 'package:flutter_taxi_tigui/splashScrum/splashScrum.dart';
import 'package:flutter_taxi_tigui/widgets/progressDialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:flutter_geofire/flutter_geofire.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(12.6120094, -8.0146979),
    zoom: 15,
  );

  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  Position? userCurrentPosition;

  String userName = "";
  String userEmail = "";

  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPaddingOfMap = 0;

  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  bool activeNearbyDriverKeysLoaded = false;

  BitmapDescriptor? activeNearbyIcon;

  double searchLocationContainerHeight = 200;
  double suggestedRidesContainerHeight = 0;
  double searchingForDriverContainerHeight = 0;
  double  waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContaineHeight = 0;

  String selectedVehiculeType = "";

  DatabaseReference? referenceRideRequest;

  String driverRideStatus = "Chauffeur arrive";

  StreamSubscription<DatabaseEvent>? tripRideRequestinfoStreamSubscription;

  String userRideRequestStatus = "";

  List<ActiveNearbyAvailableDriver> onlineActiveNearbyAvailableDriverList = [];

  bool requestPositionInfo = true;

  // bool darkTheme = false;

  Future<void> locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    userCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAdress =
        await AssistanceMethode.searchAddressForGeographieCoordonnee(
            userCurrentPosition!, context);
    print("votre adresse: " + humanReadableAdress);

    userName = userModelCurrentInfo!.nom!;
    userEmail = userModelCurrentInfo!.email!;

    initializeGeoFireListener();

    // AssistanceMethode.readCurrentOnlineInfo(context);
  }

  // initialiser geofire du drivers
  initializeGeoFireListener() {
    Geofire.initialize("activeDrivers");

    Geofire.queryAtLocation(
            userCurrentPosition!.latitude, userCurrentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callback = map["callBack"];

        switch (callback) {
          // chaque fois qu'un drivers devient actif/en ligne
          case Geofire.onKeyEntered:
            ActiveNearbyAvailableDriver activeNearbyAvailableDriver =
                ActiveNearbyAvailableDriver();
            activeNearbyAvailableDriver.locationLatitude = map["latitude"];
            activeNearbyAvailableDriver.locationLongitude = map["longitude"];
            print(
                "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
            print(activeNearbyAvailableDriver.toString());
            print(
                "eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
            activeNearbyAvailableDriver.driverId = map["key"];
            GeofireAssistance.activeNearbyAvailableDriverList
                .add(activeNearbyAvailableDriver);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriverOnUsersMap();
            }
            break;

          // chaque fois qu'un drivers devient non actif/en ligne
          case Geofire.onKeyExited:
            GeofireAssistance.deleteOffLineDriverFromList(map["key"]);
            displayActiveDriverOnUsersMap();
            break;

          // quand le chauffeur se déplace - mettre à jour l'emplacement du chauffeur
          case Geofire.onKeyMoved:
            ActiveNearbyAvailableDriver activeNearbyAvailableDriver =
                ActiveNearbyAvailableDriver();
            activeNearbyAvailableDriver.locationLatitude = map["latitude"];
            activeNearbyAvailableDriver.locationLongitude = map["longitude"];
            activeNearbyAvailableDriver.driverId = map["key"];
            GeofireAssistance.updateActiveNearbyAvailableDriverLocation(
                activeNearbyAvailableDriver);
            displayActiveDriverOnUsersMap();
            break;

          // afficher ces chauffeur actifs en ligne sur la carte de l'utilisateur
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriverOnUsersMap();
            break;
        }
      }
      setState(() {});
    });
  }

  displayActiveDriverOnUsersMap() {
    setState(() {
      markersSet.clear();
      circlesSet.clear();
      Set<Marker> driverMarker = Set<Marker>();
      final activeNearbyAvailableDriverList =
          GeofireAssistance.activeNearbyAvailableDriverList;

      for (ActiveNearbyAvailableDriver eachDriver
          in activeNearbyAvailableDriverList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );

        driverMarker.add(marker);
      }

      setState(() {
        markersSet = driverMarker;
      });
      print("");
    });
  }

  Future<void> createActiveNearByDriverIconMarker() async {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context);
      final value = await BitmapDescriptor.fromAssetImage(
          imageConfiguration, "assets/icons/taxi.png");
      activeNearbyIcon = value;
    }
  }

  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async {
    var originPosition =
        Provider.of<AppInfo>(context, listen: false).userPickeUpLocation;
    var destinationPosition =
        Provider.of<AppInfo>(context, listen: false).userDropOfLocation;

    var originLatLng = LatLng(
        originPosition!.locationLagitude!, originPosition.locationLongitude!);
    var destinationLatLng = LatLng(destinationPosition!.locationLagitude!,
        destinationPosition.locationLongitude!);

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        message: "Vueuillez patientez....",
      ),
    );

    var directionDetailsInfo =
        await AssistanceMethode.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    setState(() {
      tripDirectionDetailsInfo = directionDetailsInfo;
    });

    Navigator.pop(context);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointResult =
        pPoints.decodePolyline(directionDetailsInfo.e_points!);
    print(
        "#################################################################################");
    print(decodePolyLinePointResult);

    pLineCoordinatedList.clear();

    if (decodePolyLinePointResult.isNotEmpty) {
      decodePolyLinePointResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinatedList
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }

    polylineSet.clear();

    setState(() {
      Polyline polyline = Polyline(
          color: MesCouleur().couleurPrincipal,
          polylineId: PolylineId("PolylineID"),
          jointType: JointType.round,
          points: pLineCoordinatedList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5);

      polylineSet.add(polyline);
    });

    LatLngBounds boundsLatLng;

    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
          northeast:
              LatLng(destinationLatLng.latitude, originLatLng.longitude));
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
          northeast:
              LatLng(originLatLng.latitude, destinationLatLng.longitude));
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarket = Marker(
      markerId: MarkerId("originID"),
      infoWindow: InfoWindow(
          title: originPosition.locationName, snippet: "Point de départ"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    Marker destinationMarket = Marker(
      markerId: MarkerId("destinationID"),
      infoWindow: InfoWindow(
          title: destinationPosition.locationName, snippet: "Destination"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
    );

    setState(() {
      markersSet.add(originMarket);
      markersSet.add(destinationMarket);
    });

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.black,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );

    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.black,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    setState(() {
      circlesSet.add(originCircle);
      circlesSet.add(destinationCircle);
    });
  }

  Future<void> showSearchingForDriverContainer() async{
    setState(() {
      searchLocationContainerHeight = 200;
    });
  }

  showSuggestedRidesContainer() {
    setState(() {
      suggestedRidesContainerHeight = 460;
      bottomPaddingOfMap = 400;
    });
  }

  // getAddressFromLagLng() async{
  //   try {
  //     GeoData data = await Geocoder2.getDataFromCoordinates(
  //       latitude: pickLocation!.latitude,
  //       longitude: pickLocation!.longitude,
  //       googleMapApiKey: apiKey);

  //       setState(() {
  //         Direction userPickUpAddress = Direction();
  //         userPickUpAddress.locationLagitude = pickLocation!.latitude;
  //         userPickUpAddress.locationLongitude = pickLocation!.longitude;
  //         userPickUpAddress.locationName = data.address;
  //         // _address = data.address;
  //         // print("Recuperer adresse =>#################################################################");
  //         //  print(locationName);
  //         // print(_address);
  //         Provider.of<AppInfo>(context, listen: false).updatePickupLocationAdress(userPickUpAddress);

  //       });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  Future<void> checkLocationPermissionAlowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  saveRideRequestInformation(String selectedVehiculeType){
    // 1 enregistrer les reservations
    referenceRideRequest = FirebaseDatabase.instance.ref().child("All Ride Request");
    var originLocation = Provider.of<AppInfo>(context, listen: false).userPickeUpLocation;
    var destinationLocation = Provider.of<AppInfo>(context, listen: false).userPickeUpLocation;

    Map originLocationMap = {
      // key: value
      "latitude": originLocation!.locationLagitude.toString(),
      "longitude": originLocation!.locationLongitude.toString(),

    };

    Map destinationLocationMap = {
      // key: value
      "latitude": destinationLocation!.locationLagitude.toString(),
      "longitude": destinationLocation!.locationLongitude.toString(),

    };

    Map userInformationMap = {
      "origin" : originLocationMap,
      "destination" : destinationLocationMap,
      "time" : DateTime.now().toString(),
      "username" : userModelCurrentInfo!.nom,
      "userphone" : userModelCurrentInfo!.phone,
      "originAdress" : originLocation.locationName,
      "destinationAdress" : destinationLocation.locationName,
      "driverId" : "waiting",
    };

    referenceRideRequest!.set(userInformationMap);

    tripRideRequestinfoStreamSubscription = referenceRideRequest!.onValue.listen((eventSnap) {
        
      if (eventSnap.snapshot.value == null) {
        return;
      }
      if ((eventSnap.snapshot.value as Map)["details_car"] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["details_car"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverCarDetails = (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        setState(() {
          userRideRequestStatus = (eventSnap.snapshot.value as Map)["status"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        setState(() async {
          double driverCurrentPositionLat = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["latitude"].toString());
          double driverCurrentPositionLong = double.parse((eventSnap.snapshot.value as Map)["driverLocation"]["longitude"].toString());

          LatLng driverCurrentPositionLatLng = LatLng(driverCurrentPositionLat, driverCurrentPositionLong);

          // status = accepted
          if (userRideRequestStatus == "accepted") {
            updateArrivalTimeToUserPickUpLocatio(driverCurrentPositionLatLng);
          }
          // status = arrived
          if (userRideRequestStatus == "arrived") {
            setState(() {
              driverRideStatus = "Chauffeur est arrivé ";
            });
          }
          // status = en deplacement
          if (userRideRequestStatus == "ontrip") {
            updateReachingTimeToUseDropOffLocation(driverCurrentPositionLatLng);
          }
          // status = terminer
          // if (userRideRequestStatus == "ended") {
          //   if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
          //     double fareAmount = double.parse((eventSnap.snapshot.value as Map)["fareAmount"].toString());

          //     var response = await showDialog(
          //       context: context, 
          //       builder: (BuildContext context) => PayFareAmountDialog(
          //         fareAmount: fareAmount,
          //       )
          //       )

          //       if (response == "cash Paid") {
          //         if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
          //           String assigneDriverId = (eventSnap.snapshot.value as Map)["driverId"].toString();

          //           referenceRideRequest!.onDisconnect();
          //           tripRideRequestinfoStreamSubscription!.cancel();
          //         }
          //       }
          //   }
          // }
        });
      }
    });

    onlineActiveNearbyAvailableDriverList = GeofireAssistance.activeNearbyAvailableDriverList;
    searchNearestOnlineDrivers(selectedVehiculeType);

  }

  searchNearestOnlineDrivers(String selectedVehiculeType) async{
    if (onlineActiveNearbyAvailableDriverList.length == 0) {
      referenceRideRequest!.remove();

      setState(() {
        polylineSet.clear();
        markersSet.clear();
        circlesSet.clear();pLineCoordinatedList.clear();
      });
      Fluttertoast.showToast(msg: "Pas de chauffeur en ligne disponible le plus proche");
      Fluttertoast.showToast(msg: "chercher à nouveau \n Redémarrage de App");

      Future.delayed(Duration(milliseconds: 4000), (){
        referenceRideRequest!.remove();
        Navigator.push(context, MaterialPageRoute(builder: (c) => Slapsh(),));
      });
      return;
    }
    await retrieveOnLineDriverInformation(onlineActiveNearbyAvailableDriverList);
    print("information du cle driver" +driversList.toString());

    for (var i = 0; i < driversList.length; i++) {
      if (driversList[i]["details_car"]["type"] == selectedVehiculeType) {
        AssistanceMethode.sendNotificationToDriverNow(driversList[i]["token"],referenceRideRequest!.key!, context);
      }
    }

    Fluttertoast.showToast(msg: "Notification envoyé avec succè");

    showSearchingForDriverContainer();

    await FirebaseDatabase.instance.ref().child("All Ride Requests").child(referenceRideRequest!.key!).onValue.listen((eventRideRequestSnapshot) { 
      print("EventSnapshot: ${eventRideRequestSnapshot.snapshot.value}");
      if (eventRideRequestSnapshot.snapshot.value != null) {
        if (eventRideRequestSnapshot.snapshot.value != "waiting") {
          showUIForAssigneDriverInfo();
        }
      }
    });
  }

  Future updateArrivalTimeToUserPickUpLocatio(driverCurrentPositionLatLng) async{
    if (requestPositionInfo == true) {
      requestPositionInfo = true;
      LatLng userPickeUpLocation = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

      var directionDetailsInfo = await AssistanceMethode.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng, userPickeUpLocation);

      if (directionDetailsInfo == null) {
        return;
      }

      setState(() {
        driverRideStatus = " Chauffeur arrive :" +directionDetailsInfo.duration_text.toString(); 
      });

      requestPositionInfo = true;
    }
  }

  Future updateReachingTimeToUseDropOffLocation(driverCurrentPositionLatLng) async{
    if (requestPositionInfo == true) {
      requestPositionInfo = false;

      var dropOffLocation = Provider.of<AppInfo>(context, listen: false).userDropOfLocation;

      LatLng userDestionationInfo = LatLng(dropOffLocation!.locationLagitude!, dropOffLocation.locationLongitude!);
      var directionDetailsInfo = await AssistanceMethode.obtainOriginToDestinationDirectionDetails(driverCurrentPositionLatLng, userDestionationInfo);
      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus = "Aller vers la destination " +directionDetailsInfo.duration_text.toString();
      });
      requestPositionInfo = true;
    }
  }

  Future showUIForAssigneDriverInfo() async{
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverInfoContaineHeight = 200;
      suggestedRidesContainerHeight = 0;
      bottomPaddingOfMap = 200;
    });
  }

  retrieveOnLineDriverInformation(List onLineNearesDriversList) async{
    driversList.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("drivers");

    for (int i = 0; i < onLineNearesDriversList.length; i++) {
      await ref.child(onLineNearesDriversList[i].driverId.toString()).once().then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;
        driversList.add(driverKeyInfo);
        print("information du cle de driver" +driversList.toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future(() async => await checkLocationPermissionAlowed());
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    Future(() async => await createActiveNearByDriverIconMarker());
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldState,
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) async {
                _googleMapController.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 200;
                });
                await locateUserPosition();
                // createActiveNearByDriverIconMarker();
              },
              // onCameraMove: (CameraPosition? position){
              //   if (pickLocation != position!.target ) {
              //     setState(() {
              //       pickLocation = position.target;
              //     });
              //   }
              // },
              // onCameraIdle: (){
              //   getAddressFromLagLng();
              // },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.location,
                                          color: Color(0xFFEDB602)),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Départ",
                                            style: TextStyle(
                                                color: MesCouleur()
                                                    .couleurPrincipal,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                          Text(
                                            Provider.of<AppInfo>(context)
                                                        .userPickeUpLocation !=
                                                    null
                                                ? (Provider.of<AppInfo>(context)
                                                    .userPickeUpLocation!
                                                    .locationName!)
                                                : "Votre adresse de depart",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 16),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: MesCouleur().couleurPrincipal,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await Future(() => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => FormAdresse())));

                                      setState(() {
                                        bottomPaddingOfMap = 100;
                                      });

                                      await drawPolyLineFromOriginToDestination(
                                          darkTheme);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          color: MesCouleur().couleurPrincipal,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Destination",
                                              style: TextStyle(
                                                  color: MesCouleur()
                                                      .couleurPrincipal,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              Provider.of<AppInfo>(context)
                                                          .userDropOfLocation !=
                                                      null
                                                  ? Provider.of<AppInfo>(
                                                          context)
                                                      .userDropOfLocation!
                                                      .locationName!
                                                  : "Où voulez-vous aller ?",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                PreciserDepart())));
                                  },
                                  child: Text(
                                    "Position actuelle",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (Provider.of<AppInfo>(context, listen: false).userDropOfLocation != null) {
                                    showSuggestedRidesContainer();
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Selectionner une destination");
                                  }
                                },
                                child: Text(
                                  "Obtenir les tarifs",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // choix du vehicule
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: suggestedRidesContainerHeight,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50))),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: MesCouleur().couleurPrincipal,
                                    borderRadius: BorderRadius.circular(2)),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userPickeUpLocation != null
                                    ? (Provider.of<AppInfo>(context)
                                        .userPickeUpLocation!
                                        .locationName!)
                                    : "Votre adresse de depart",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(2)),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppInfo>(context).userDropOfLocation !=null
                                    ? Provider.of<AppInfo>(context).userDropOfLocation!.locationName!
                                    : "Où voulez-vous aller ?",
                                style:
                                    TextStyle(color: MesCouleur().couleurPrincipal,fontWeight: FontWeight.bold, fontSize: 16),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          "Choix du véhicule",
                          style: TextStyle(
                            color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18,
                          ),
                        ),

                        SizedBox(height: 10,),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedVehiculeType = "moto";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedVehiculeType == "moto" ? MesCouleur().couleurPrincipal : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/moto.png",),
                                    SizedBox(height: 6,),
                                    Text("Moto",style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "moto" ? Colors.white : Colors.black,), ),
                                    SizedBox(height: 6,),
                                    Text(
                                       tripDirectionDetailsInfo != null ? "${((AssistanceMethode.calculFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)*2) *50).toStringAsFixed(1)}"
                                        : "Null",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "moto" ? Colors.white : MesCouleur().couleurPrincipal,), 
                                      ),
                                    Text("FCFA", style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "moto" ? Colors.white : MesCouleur().couleurPrincipal,),)
                                  ],
                                ),
                              ),
                            ),
                            
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedVehiculeType = "Economie";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedVehiculeType == "Economie" ? MesCouleur().couleurPrincipal : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/car.png",),
                                    SizedBox(height: 6,),
                                    Text("Economie",style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "Economie" ? Colors.white : Colors.black,), ),
                                    SizedBox(height: 6,),
                                    Text(
                                        tripDirectionDetailsInfo != null ? "${((AssistanceMethode.calculFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)*2) *88).toStringAsFixed(1)}"
                                        : "Null",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "Economie" ? Colors.white : MesCouleur().couleurPrincipal,),
                                      ),
                                    Text("FCFA", style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "Economie" ? Colors.white : MesCouleur().couleurPrincipal,),)
                                  ],
                                ),
                              ),
                            ),

                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedVehiculeType = "prenium";
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: selectedVehiculeType == "prenium" ? MesCouleur().couleurPrincipal : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/4.png",),
                                    SizedBox(height: 6,),
                                    Text("prenium",style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "prenium" ? Colors.white : Colors.black,), ),
                                    SizedBox(height: 6,),
                                    Text(
                                        tripDirectionDetailsInfo != null ? "${((AssistanceMethode.calculFareAmountFromOriginToDestination(tripDirectionDetailsInfo!)*2) *107).toStringAsFixed(1)}"
                                        : "Null",
                                      style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "prenium" ? Colors.white : MesCouleur().couleurPrincipal,),
                                      ),
                                    Text("FCFA", style: TextStyle(fontWeight: FontWeight.bold,color: selectedVehiculeType == "prenium" ? Colors.white : MesCouleur().couleurPrincipal,),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10,),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => accueil()));
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Icon(Icons.arrow_back_ios, color: Colors.white,),
                                        Text(
                                          "Annuler",
                                          style: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              ),
                              SizedBox(height: 75,width: 5,),
                              Container(
                              child: GestureDetector(
                                onTap: () {
                                  if (selectedVehiculeType != "") {
                                    saveRideRequestInformation(selectedVehiculeType);
                                  }else{
                                    Fluttertoast.showToast(msg: "Selectionner un véhicule");
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: MesCouleur().couleurPrincipal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Text(
                                          "Continuer",
                                          style: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        // Icon(Icons.arrow_back_ios, color: Colors.white,)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
            // InputSearch(),
          ],
        ),
      ),
    );
  }
}
