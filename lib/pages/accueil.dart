import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/paiement.dart';
import 'package:flutter_taxi_tigui/pages/profil.dart';
import 'package:flutter_taxi_tigui/pages/trajet.dart';
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
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration:  BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 85, 85, 85).withOpacity(0.5),
                blurRadius: 25,
                offset: const Offset(8, 20),
              )
            ]
          ),
          child: ClipRRect(
           borderRadius: BorderRadius.circular(10),
            child: BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: const Color(0xFFEDB602),
            unselectedItemColor: Color.fromARGB(255, 51, 51, 51),
            currentIndex: indexCourant,
            onTap: (index){
              setState(() {
                indexCourant = index;
              });
            },
            items: [
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.houseChimneyUser), label: "Accueil"),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.wallet), label: "Paiement"),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.locationDot), label: "Trajet"),
            BottomNavigationBarItem(icon: Icon(FontAwesomeIcons.user), label: "Profil"),
                ],),
          ),
        ),
    );
  }
}
