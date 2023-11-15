import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_taxi_tigui/assistance/assistanceMethode.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/infoHandler/app_info.dart';
import 'package:flutter_taxi_tigui/models/direction.dart';
import 'package:flutter_taxi_tigui/pages/APIkey.dart';
import 'package:flutter_taxi_tigui/pages/formAdresse.dart';
import 'package:flutter_taxi_tigui/widgets/progressDialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_taxi_tigui/widgets/inputSearch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';


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

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  

  Position? userCurrentPosition;

  String userName = "";
  String userEmail = "";
  

  var geoLocation = Geolocator();

  LocationPermission? _locationPermission;
  
  List<LatLng> pLineCoordinatedList = [];
  Set<Polyline> polylineSet = {};

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  // bool darkTheme = false;
  
  

  locateUserPosition() async{

    Position cPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high); 

    userCurrentPosition = cPosition;
    
    LatLng latLngPosition = LatLng(userCurrentPosition!.latitude, userCurrentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);
    
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    
    String humanReadableAdress = await AssistanceMethode.searchAddressForGeographieCoordonnee(userCurrentPosition!, context);
    print("votre adresse: "+ humanReadableAdress);

    userName = userModelCurrentInfo!.nom!;
    userEmail = userModelCurrentInfo!.email!;
    

    // initializeGeoFireListener();

    // AssistanceMethode.readCurrentOnlineInfo(context);
    
  }

  Future<void> drawPolyLineFromOriginToDestination(bool darkTheme) async{
    var originPosition = Provider.of<AppInfo>(context, listen: false).userPickeUpLocation;
    var destinationPosition = Provider.of<AppInfo>(context, listen: false).userDropOfLocation;

    var originLatLng = LatLng(originPosition!.locationLagitude!, originPosition.locationLongitude!);
    var destinationLagLng = LatLng(destinationPosition!.locationLagitude!, destinationPosition.locationLongitude!);

    //  print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    //  print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    //  print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
    //  print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
      

    //   print(originLatLng);
    //   print(destinationLagLng);

    showDialog(
      context: context, 
      builder: (BuildContext context) => ProgressDialog(message: "Vueuillez patientez....",),
      );

      var directionDetailsInfo = await AssistanceMethode.obtainOriginToDestinationDirectionDetails(originLatLng, destinationLagLng);

      setState(() {
        tripDirectionDetailsInfo = directionDetailsInfo;
      });

      Navigator.pop(context);

      PolylinePoints pPoints = PolylinePoints();
      List<PointLatLng> decodePolyLinePointResult = pPoints.decodePolyline(directionDetailsInfo.e_points!);

      

      pLineCoordinatedList.clear();

      if (decodePolyLinePointResult.isNotEmpty) {
        decodePolyLinePointResult.forEach((PointLatLng pointLatLng) { 
          pLineCoordinatedList.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));

        });
      }

      polylineSet.clear();

      setState(() {
        Polyline polyline = Polyline(
          color: MesCouleur().couleurPrincipal,
          polylineId: PolylineId("PolylineId"),
          jointType: JointType.round,
          points: pLineCoordinatedList,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5
          );

          polylineSet.add(polyline);
      });

      LatLngBounds boundsLatLng;

      if (originLatLng.latitude > destinationLagLng.latitude && originLatLng.longitude > destinationLagLng.longitude) {
        boundsLatLng = LatLngBounds(
          southwest: destinationLagLng, 
          northeast: originLatLng
          );
      }
      else if(originLatLng.longitude > destinationLagLng.longitude){
        boundsLatLng = LatLngBounds(
          southwest: LatLng(originLatLng.latitude, destinationLagLng.longitude),
          northeast: LatLng(destinationLagLng.latitude, originLatLng.longitude));
      }
      else if(originLatLng.latitude > destinationLagLng.latitude){
         boundsLatLng = LatLngBounds(
          southwest: LatLng(destinationLagLng.latitude, originLatLng.longitude),
          northeast: LatLng(originLatLng.latitude, destinationLagLng.longitude));
      }
      else {
        boundsLatLng = LatLngBounds(southwest: originLatLng, northeast: destinationLagLng);
      }

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 45));
     



      
  }

  getAddressFromLagLng() async{
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude, 
        longitude: pickLocation!.longitude,
        googleMapApiKey: apiKey);
        
        setState(() {
          Direction userPickUpAddress = Direction();
          userPickUpAddress.locationLagitude = pickLocation!.latitude;
          userPickUpAddress.locationLongitude = pickLocation!.longitude;
          userPickUpAddress.locationName = data.address;
          // _address = data.address;
          // print("Recuperer adresse =>#################################################################");
          //  print(locationName);
          // print(_address);
          Provider.of<AppInfo>(context, listen: false).updatePickupLocationAdress(userPickUpAddress);

        });
    } catch (e) {
      print(e);
    }
  }


  checkLocationPermissionAlowed() async{
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationPermissionAlowed();
  }
 

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return  GestureDetector(
         onTap: (){
          FocusScope.of(context).unfocus();
         },
         child: Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                mapType: MapType.normal,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                zoomGesturesEnabled: true,
                initialCameraPosition: _kGooglePlex,
                polylines: polylineSet,
                markers: markersSet,
                circles: circlesSet,
                onMapCreated: (GoogleMapController controller){
                  _googleMapController.complete(controller);
                  newGoogleMapController = controller;

                 setState(() {
                   
                 });

                 locateUserPosition();
                  
                },
                onCameraMove: (CameraPosition? position){
                  if (pickLocation != position!.target ) {
                    setState(() {
                      pickLocation = position.target;
                    });
                  }
                },
                onCameraIdle: (){
                  getAddressFromLagLng();
                },
                
              ),
              Align(
                alignment: Alignment.center,
               child: Padding(
                padding: EdgeInsets.only(bottom: 35),
                child: Icon(
                  Icons.location_on_outlined,
                  color: MesCouleur().couleurPrincipal,
                  size: 40,
                ),
                ),
              ),
            // Positioned(
            //   top: 40,
            //   right: 20,
            //   left: 20,
            //     child: Container(
            //   decoration:
            //       BoxDecoration(
            //       border: Border.all(color: Colors.black),
            //       color: Colors.white
            //       ),
            //       padding: EdgeInsets.all(20),
            //     child: Text(
            //       Provider.of<AppInfo>(context).userPickeUpLocation !=null
            //       ? Provider.of<AppInfo>(context).userPickeUpLocation!.locationName!
            //       : "Address",
            //       overflow: TextOverflow.visible, softWrap: true,
            //     ),
            //   ),
            // ),

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
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.location, color: Color(0xFFEDB602)),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Départ",
                                        style: TextStyle(color: MesCouleur().couleurPrincipal, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                        Provider.of<AppInfo>(context).userPickeUpLocation !=null
                                        ? (Provider.of<AppInfo>(context).userPickeUpLocation!.locationName!)
                                        : "Votre adresse de depart", 
                                        style: TextStyle(color: Colors.grey, fontSize: 16),)
                                      ],
                                    )
                                  ],
                                ),
                                ),
                                SizedBox(height: 5,),

                                Divider(
                                  height: 1,
                                  thickness: 2,
                                  color: MesCouleur().couleurPrincipal,
                                ),
                                SizedBox(height: 5,),

                                Padding(
                                  padding: EdgeInsets.all(5),
                                  child: GestureDetector(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(builder: (c)=> FormAdresse()));
                                      // if (responseFromSearch == "") {
                                        
                                      // }

                                      print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                      print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                      print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                                      print("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT");
                   
                                      await drawPolyLineFromOriginToDestination(darkTheme);
                                    },
                                    child: Row(
                                  children: [
                                    Icon(Icons.location_on, color: MesCouleur().couleurPrincipal,),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("Destination",
                                        style: TextStyle(color: MesCouleur().couleurPrincipal, fontWeight: FontWeight.bold, fontSize: 14),
                                        ),
                                        Text(
                                        Provider.of<AppInfo>(context).userDropOfLocation != null
                                        ? Provider.of<AppInfo>(context).userDropOfLocation!.locationName!
                                        : "Où voulez-vous aller ?", 
                                        style: TextStyle(color: Colors.grey, fontSize: 16),)
                                      ],
                                    )
                                  ],
                                ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ),
            ),
              
              // InputSearch(),
            ],
          ),
         ),
       );
  }
}

