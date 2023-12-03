import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';

class Apropos extends StatefulWidget {
  const Apropos({super.key});

  @override
  State<Apropos> createState() => _AproposState();
}

class _AproposState extends State<Apropos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "A propos",
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
    );
  }
}