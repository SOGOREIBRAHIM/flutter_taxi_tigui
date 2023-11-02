import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';

void main() {
  runApp(const TaxiTigui());
}

class TaxiTigui extends StatelessWidget {
  const TaxiTigui({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: accueil(),
    );
  }
}