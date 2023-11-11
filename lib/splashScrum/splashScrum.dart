import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/assistance/assistanceMethode.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';
import 'package:flutter_taxi_tigui/pages/sign.dart';

class Slapsh extends StatefulWidget {
  const Slapsh({super.key});

  @override
  State<Slapsh> createState() => _SlapshState();
}

class _SlapshState extends State<Slapsh> {

  startTime(){
    Timer(Duration(seconds:10), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null ? AssistanceMethode.readCurrentOnlineInfo() : null;
        Navigator.push(context, MaterialPageRoute(builder: ((context) => Connexion())));
      }
      else{
        Navigator.push(context, MaterialPageRoute(builder: ((context) => Connexion())));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
          child: Image.asset(
        "assets/images/demarrage.png",
        height: 1200,
      )),
    );
  }
}
