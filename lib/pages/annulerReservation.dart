import 'package:flutter/material.dart';

class AnnulerReservation extends StatefulWidget {
  const AnnulerReservation({super.key});

  @override
  State<AnnulerReservation> createState() => _AnnulerReservationState();
}

class _AnnulerReservationState extends State<AnnulerReservation> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(
          "Annuler reservation"
          ),),
    );
  }
}