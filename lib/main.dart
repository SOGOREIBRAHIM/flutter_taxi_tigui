import 'package:flutter/material.dart';

import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/annulerReservation.dart';
import 'package:flutter_taxi_tigui/pages/apropos.dart';
import 'package:flutter_taxi_tigui/pages/devenirChauffeur.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const TaxiTigui());
}

class TaxiTigui extends StatelessWidget {
  const TaxiTigui({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TAXI TIGUI",
      theme: ThemeData(
        splashColor: Color(0xFFEDB602),
        primarySwatch: Colors.amber,
        fontFamily: "Poppins"
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/devenirChauffeur": (context) => DevenirChauffeur(),
        "/annulerReservation": (context) => AnnulerReservation(),
        "/apropos": (context) => Apropos(),
      },
      home: Connexion(),
    );
  }
}
