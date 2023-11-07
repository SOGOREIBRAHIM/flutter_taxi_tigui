import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';
import 'package:flutter_taxi_tigui/pages/paiement.dart';
import 'package:flutter_taxi_tigui/pages/profil.dart';
import 'package:flutter_taxi_tigui/pages/sign.dart';
import 'package:flutter_taxi_tigui/pages/trajet.dart';
import 'package:flutter_taxi_tigui/pages/vehicule.dart';
import 'package:flutter_taxi_tigui/widgets/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class accueil extends StatefulWidget {
  const accueil({super.key});

  @override
  State<accueil> createState() => _accueilState();
}

class _accueilState extends State<accueil> {

  int indexCourant = 0;
  List pages = [
    Home(),
    Paiement(),
    Trajet(),
    Profil(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[indexCourant],
      bottomNavigationBar: 
        Container(
          
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration:  BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 59, 59, 59).withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20),
              )
            ]
          ),
          child: ClipRRect(
           borderRadius: BorderRadius.circular(50),
            child: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
            selectedItemColor: const Color(0xFFEDB602),
            unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
            currentIndex: indexCourant,
            onTap: (index){
              setState(() {
                indexCourant = index;
              });
            },
            items:  [
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.house), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.wallet), label: "Sign"),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.route,), label: "Trajet"),
            BottomNavigationBarItem(icon: Icon(Icons.person_2,size: 35), label: "Profil"),
                ],),
          ),
        ),
    );
  }
}
