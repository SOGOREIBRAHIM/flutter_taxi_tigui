import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/assistance/assistanceMethode.dart';
import 'package:flutter_taxi_tigui/pages/APIkey.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_taxi_tigui/widgets/inputSearch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;


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
  String? _adress;

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  

  Position? userCurrentPosition;
  

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
    print(latLngPosition);

    CameraPosition cameraPosition = CameraPosition(target: latLngPosition, zoom: 15);
    
    newGoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    
    String humanReadableAdress = await AssistanceMethode.searchAddressForGeographieCoordonnee(userCurrentPosition!, context);
    print("ddddddddddddddddd&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"+humanReadableAdress);
    
    
  }

  getAddressFromLagLng() async{
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: pickLocation!.latitude, 
        longitude: pickLocation!.longitude,
        googleMapApiKey: apiKey);
        setState(() {
          _adress = data.address;
        });
    } catch (e) {
      print(e);
    }
  }




  checkLocationPermission() async{
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLocationPermission;
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
              InputSearch(),
            ],
          ),
         ),
       );
  }
}

