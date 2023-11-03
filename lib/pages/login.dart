import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Connexion extends StatefulWidget {
  const Connexion({super.key});

  @override
  State<Connexion> createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child:  Text(
            "Connexion",
            style: TextStyle(
              color: Color(0xFFEDB602),
            ),
          ),
        ),
      ),
      body:  Container(
        decoration: BoxDecoration(
          color: Color(0xFFEDB602),
        ),
        child: Column(
          children: [
            Image.asset("assets/images/3.png", width: 340),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                     color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70))),
                  padding: const EdgeInsets.only(top: 50, left: 60,right: 60),
                  child: Column(
                    children: [
                  SizedBox(height: 8),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Email",
                      suffixIcon: Icon(Icons.email,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 25),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Mot de passe",
                      suffixIcon: Icon(FontAwesomeIcons.lock,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                  child: Text('CONNEXION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEDB602),
                    padding: EdgeInsets.fromLTRB(105, 15, 105, 15),
                  ),
                    onPressed: () {},
                  ),
                  SizedBox(height: 30),
                  Image.asset("assets/images/ou.png", width: 340),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset("assets/images/google.png"),
                      Image.asset("assets/images/facebook.png"),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Vous n’avez pas de compte ?", style: TextStyle(
                        fontSize: 13
                      ),),
                      Text("S’inscrire", style: TextStyle(
                        fontSize: 15,
                        color: Color(0xFFEDB602),
                      ),),
                    ],
                  )
                ],
             )
                   
          ),
              )
            
            )
          ],
        )
      )
    );
  }
}
