import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnnulerReservation extends StatefulWidget {
  const AnnulerReservation({super.key});

  @override
  State<AnnulerReservation> createState() => _AnnulerReservationState();
}

class _AnnulerReservationState extends State<AnnulerReservation> {

  String causeSelectionner = "";
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Annuler reservation",
          style: TextStyle(color: Color(0xFFEDB602),fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => accueil()),
              );
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFFEDB602),
              size: 30,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 60,),
            Center(child: Text("Que s’est-il passé ?", style: TextStyle(color: MesCouleur().couleurPrincipal, fontSize: 20),)),
            Padding(
              padding: const EdgeInsets.only(top: 90,left: 10),
              child: Column(
                children: [
                  GestureDetector(
                     onTap: (){
                      setState(() {
                        causeSelectionner = "vient pas";
                      });
                     },
                    child: Row(
                      children: [
                        SizedBox(height: 60,),
                        Image(image: AssetImage(("assets/icons/d.png")),color: MesCouleur().couleurPrincipal,),
                        SizedBox(width: 20,),
                        Text("Le chauffeur ne vient pas", style: TextStyle(color:causeSelectionner == "vient pas" ? MesCouleur().couleurPrincipal : Colors.black,  fontSize: 16)),
                      ],
                    ),
                  ),
                  GestureDetector(
                     onTap: (){
                      setState(() {
                        causeSelectionner = "refuser";
                      });
                     },
                    child: Row(
                      children: [
                        SizedBox(height: 60,),
                        Image(image: AssetImage(("assets/icons/e.png")),color: MesCouleur().couleurPrincipal,),
                        SizedBox(width: 20,),
                        Text("Le chauffeur a refusé de vous conduire", style: TextStyle(color:causeSelectionner == "refuser" ? MesCouleur().couleurPrincipal : Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                  GestureDetector(
                     onTap: (){
                      setState(() {
                        causeSelectionner = "temps";
                      });
                     },
                    child: Row(
                      children: [
                        SizedBox(height: 60,),
                        Image(image: AssetImage(("assets/icons/a.png")),color: MesCouleur().couleurPrincipal,),
                        SizedBox(width: 20,),
                        Text("Le chauffeur prend trop de temps", style: TextStyle(color: causeSelectionner=="temps" ? MesCouleur().couleurPrincipal : Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        causeSelectionner="destination";
                      });
                    },
                    child: Row(
                      children: [
                        SizedBox(height: 60,),
                        Image(image: AssetImage(("assets/icons/b.png")),color: MesCouleur().couleurPrincipal,),
                        SizedBox(width: 20,),
                        Text("Je souhaite modifier la destination", style: TextStyle(color:causeSelectionner == "destination" ? MesCouleur().couleurPrincipal : Colors.black, fontSize: 16)),
                      ],
                    ),
                  ),
                  SizedBox(height: 30,),
                 GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 250,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF878787),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "Autre raison",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                   SizedBox(height: 160,),
                 GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 380,
                      padding:
                          EdgeInsets.symmetric(horizontal: 75, vertical: 10),
                      decoration: BoxDecoration(
                        color: MesCouleur().couleurPrincipal,
                        
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            Text(
                              "Confirmer l'annulation",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}