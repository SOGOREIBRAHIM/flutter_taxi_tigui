import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {

static const LatLng _maPosition = LatLng(12.63074, -8.0295731);
static const LatLng _maDestination = LatLng(12.6312102,-8.0327274);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _maPosition,zoom: 15
        ),
        markers:{
          Marker(
            markerId: MarkerId("_positionCurrent"),
            icon: BitmapDescriptor.defaultMarker,
            position: _maPosition,
            ),
            Marker(
            markerId: MarkerId("_destination"),
            icon: BitmapDescriptor.defaultMarker,
            position: _maDestination,
            ),
        }
      ),
    );
  }
}