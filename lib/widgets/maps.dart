import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class Maps extends StatefulWidget {
  const Maps({super.key});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> {


String? _mapStyle;

@override
void initState() {
  super.initState();

  rootBundle.loadString('assets/map_style.txt').then((string) {
    _mapStyle = string;
  });
}

static const CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(12.6312102,-8.0327274),
  zoom: 14.4746,
);

GoogleMapController? myMapsController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: GoogleMap(
       
        onMapCreated: (GoogleMapController controller) {
          myMapsController = controller;
          myMapsController!.setMapStyle(_mapStyle);
        }, initialCameraPosition: _kGooglePlex,
      ),
    );
  }
}