import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  @override
  Widget build(BuildContext context) {
     return Scaffold( 
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(
          child:  Text(
            "Inscription",
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
            Image.asset("assets/images/1.png", width: 340,),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  decoration: const BoxDecoration(
                     color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70),
                      topRight: Radius.circular(70))),
                  padding: EdgeInsets.only(top: 50, left: 60,right: 60),
                  child: Column(
                    children: [
                      TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Prenom",
                      suffixIcon: Icon(Icons.person,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Nom",
                      suffixIcon: Icon(Icons.person,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Numéro",
                      suffixIcon: Icon(Icons.phone,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Email",
                      suffixIcon: Icon(Icons.email,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                      labelText: "Mot de passe",
                      suffixIcon: Icon(FontAwesomeIcons.lock,color: Color(0xFFEDB602)),
                      border: OutlineInputBorder()
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                  child: Text('CONNEXION'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEDB602),
                    padding: EdgeInsets.fromLTRB(105, 15, 105, 15),
                  ),
                  onPressed: () {},
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