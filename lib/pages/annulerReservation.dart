import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: Container(
            decoration: BoxDecoration(
              color: Color(0xFFEDB602),
            ),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/1.png",
                  width: 340,
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(70),
                              topRight: Radius.circular(70))),
                      padding: EdgeInsets.only(top: 50, left: 60, right: 60),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                    ),
                                    labelText: "Prenom",
                                    prefixIcon: Icon(Icons.person,
                                        color: Color(0xFFEDB602)),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                    ),
                                    labelText: "Nom",
                                    prefixIcon: Icon(Icons.person,
                                        color: Color(0xFFEDB602)),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                    ),
                                    labelText: "Numéro",
                                    prefixIcon:
                                        Icon(Icons.phone, color: Color(0xFFEDB602)),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                keyboardType: TextInputType.name,
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                    ),
                                    labelText: "Email",
                                    prefixIcon:
                                        Icon(Icons.email, color: Color(0xFFEDB602)),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                validator: (value) {},
                                // obscureText: passToggle,
                                // controller: passControler,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(
                                              0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                    ),
                                    labelText: "Mot de passe",
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.adn,
                                      color: Color(0xFFEDB602),
                                    ),
                                    suffix: InkWell(
                                      onTap: () {
                                        setState(() {
                                          // passToggle = !passToggle;
                                        });
                                      },
                                      // child: Icon(
                                      //   // passToggle
                                      //       // ? Icons.visibility
                                      //       // : Icons.visibility_off,
                                      //   // color: Color(0xFFEDB602),
                                      // ),
                                    ),
                                    border: OutlineInputBorder()),
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                child: Text('INSCRIPTION'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFEDB602),
                                  padding: EdgeInsets.fromLTRB(92, 20, 92, 20),
                                ),
                                onPressed: () {
                                  // Redirection vers la page d'inscription
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Connexion()),
                                  );
                                },
                              ),
                              SizedBox(height: 20),
                              Padding(
                                padding: EdgeInsets.only(left: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      "Vous avez un compte ?",
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        // Redirection vers la page d'inscription
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Connexion()),
                                        );
                                      },
                                      child: const Text(
                                        "Se connecter",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Color(0xFFEDB602),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 32),
                            ],
                          ),
                        ],
                      )),
                ))
              ],
            )),
    );
  }
}