import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/widgets/maps.dart';

class DrawerS extends StatefulWidget {
  const DrawerS({super.key});

  @override
  State<DrawerS> createState() => _DrawerState();
}

class _DrawerState extends State<DrawerS> {
  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            const DrawerHeader   (
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFEDB602),Color(0xFFFFFFFF)
                  ])),
              child: Row(
                children:  [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/1.png"),
                    radius: 50,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ibrahim',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'SOGORE',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              onTap: (){
               Navigator.of(context).pop();
               Navigator.pushNamed(context, "/devenirChauffeur");
            },
              leading: Image.asset("assets/images/Driver.png", color: Color(0xFFEDB602)),
              trailing: Icon(Icons.arrow_forward_ios_sharp, size: 18),
              
              title: const Text(
                "Devenir chauffeur",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18
                ),
                ),
            ),
            ListTile(
              onTap: (){
               Navigator.of(context).pop();
               Navigator.pushNamed(context, "/annulerReservation");
            },
              leading: Icon(Icons.cancel_rounded, size: 30, color: Color(0xFFEDB602)),
              trailing: Icon(Icons.arrow_forward_ios_sharp, size: 18),
              
              title: const Text(
                "Annuler reservation",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18
                ),
                ),
            ),
            ListTile(
              onTap: (){
               Navigator.of(context).pop();
               Navigator.pushNamed(context, "/apropos");
            },
              leading: Icon(Icons.help, size: 30, color: Color(0xFFEDB602)),
              trailing: Icon(Icons.arrow_forward_ios_sharp, size: 18),
              
              title: const Text(
                "Apropos",
                style: TextStyle(
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontSize: 18
                ),
                ),
            )
        ],);
  }
}