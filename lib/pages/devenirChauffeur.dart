import 'package:flutter/material.dart';

class DevenirChauffeur extends StatefulWidget {
  const DevenirChauffeur({super.key});

  @override
  State<DevenirChauffeur> createState() => _DevenirChauffeurState();
}

class _DevenirChauffeurState extends State<DevenirChauffeur> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Devenir chauffeur"
          ),),
    );
  }
}