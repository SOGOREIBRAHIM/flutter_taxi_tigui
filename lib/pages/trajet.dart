import 'package:flutter/material.dart';

class Trajet extends StatefulWidget {
  const Trajet({super.key});

  @override
  State<Trajet> createState() => _TrajetState();
}

class _TrajetState extends State<Trajet> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Pour supprimer le bouton de retour
        centerTitle: true, // Pour centrer le titre
        backgroundColor: Color(0xFFEDB602),
        elevation: 0,
        title: const Text(
          "Paiement",
          style: TextStyle(color: Color.fromARGB(255, 255, 255, 255),fontWeight: FontWeight.bold,fontSize: 25),
        ),
      ),
    );
  }
}