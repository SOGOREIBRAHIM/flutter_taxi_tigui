import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/annulerReservation.dart';
import 'package:flutter_taxi_tigui/pages/apropos.dart';
import 'package:flutter_taxi_tigui/pages/devenirChauffeur.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';

void main() {
  runApp(const TaxiTigui());
}

class TaxiTigui extends StatelessWidget {
  const TaxiTigui({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      routes: {
        "/devenirChauffeur":(context)=> DevenirChauffeur(),
        "/annulerReservation":(context)=> AnnulerReservation(),
        "/apropos":(context)=> Apropos(),
      },
      home: Connexion(),
    );
  }
}