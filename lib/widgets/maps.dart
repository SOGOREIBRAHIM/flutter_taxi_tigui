import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/assistance/assistanceMethode.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/infoHandler/app_info.dart';
import 'package:flutter_taxi_tigui/models/direction.dart';
import 'package:flutter_taxi_tigui/pages/APIkey.dart';
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

  getAddressFromLagLng() async{
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude, 
        longitude: pickLocation!.longitude,
        googleMapApiKey: apiKey);
        
        setState(() {
          Direction userPickUpAddress = Direction();
          userPickUpAddress.locationLag = pickLocation!.latitude;
          userPickUpAddress.locationLong = pickLocation!.longitude;
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
            Positioned(
              top: 40,
              right: 20,
              left: 20,
                child: Container(
              decoration:
                  BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.white
                  ),
                  padding: EdgeInsets.all(20),
                child: Text(
                  Provider.of<AppInfo>(context).userPickeUpLocation !=null
                  ? Provider.of<AppInfo>(context).userPickeUpLocation!.locationName!
                  : "Address",
                  overflow: TextOverflow.visible, softWrap: true,
                ),
              ),
            ),
              
              InputSearch(),
            ],
          ),
         ),
       );
  }
}

