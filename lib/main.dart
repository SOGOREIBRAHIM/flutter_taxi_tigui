import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/infoHandler/app_info.dart';
import 'package:flutter_taxi_tigui/pages/annulerReservation.dart';
import 'package:flutter_taxi_tigui/pages/apropos.dart';
import 'package:flutter_taxi_tigui/pages/devenirChauffeur.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_taxi_tigui/splashScrum/splashScrum.dart';
import 'package:provider/provider.dart';
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
     
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: MaterialApp(
      title: "TAXI TIGI",
      theme: ThemeData(
        colorScheme: ColorScheme.light(primary: MesCouleur().couleurPrincipal),
        splashColor: MesCouleur().couleurPrincipal,
        primarySwatch: Colors.amber,
        fontFamily: "Poppins"
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        "/devenirChauffeur": (context) => DevenirChauffeur(),
        "/annulerReservation": (context) => AnnulerReservation(),
        "/apropos": (context) => Apropos(),
      },
      home: Slapsh(),
      
    ),
    );
  }
}
