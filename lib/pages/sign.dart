import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/pages/login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final emailControler = TextEditingController();
  final passControler = TextEditingController();
  final numControler = TextEditingController();
  final nomControler = TextEditingController();
  final prenomControler = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Center(
            child: Text(
              "Inscription",
              style: TextStyle(
                color: Color(0xFFEDB602),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: MesCouleur().couleurPrincipal,
            ),
            child: Column(
              children: [
                Image.asset("assets/images/3.png"),
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(70),
                            topRight: Radius.circular(70))),
                    child: Form(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(
                                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                  ),
                                  labelText: "Nom",
                                  prefixIcon: Icon(Icons.person_2_outlined,
                                      color: Color(0xFFEDB602)),
                                  border: OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Nom ne peut pas etre vide !";
                                }
                                if (text.length < 2) {
                                  return "Nom trop court !";
                                }
                                if (text.length > 60) {
                                  return "Nom trop long, Maximuin 50 !";
                                }
                              },
                              onChanged: (text) => setState(() {
                                nomControler.text = text;
                              }),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(
                                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                  ),
                                  labelText: "Prenom",
                                  prefixIcon: Icon(Icons.person_2_outlined,
                                      color: Color(0xFFEDB602)),
                                  border: OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Prenom ne peut pas etre vide !";
                                }
                                if (text.length < 2) {
                                  return "Prenom trop court !";
                                }
                                if (text.length > 60) {
                                  return "Prenom trop long, Maximuin 50 !";
                                }
                              },
                              onChanged: (text) => setState(() {
                                prenomControler.text = text;
                              }),
                            ),
                            SizedBox(height: 10),
                            IntlPhoneField(
                              showCountryFlag: true,
                              dropdownIcon: Icon(
                                Icons.arrow_drop_down,
                                color: MesCouleur().couleurPrincipal,
                              ),
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(
                                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                  ),
                                  border: OutlineInputBorder()),
                              initialCountryCode: 'ML',
                              onChanged: (text) => setState(() {
                                numControler.text = text.completeNumber;
                              }),
                            ),
                            SizedBox(height: 5),
                            TextFormField(
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(
                                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                  ),
                                  labelText: "Email",
                                  prefixIcon: Icon(Icons.email_outlined,
                                      color: Color(0xFFEDB602)),
                                  border: OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Email ne peut pas etre vide !";
                                }
                                if (EmailValidator.validate(text)) {
                                  return null;
                                }
                                if (text.length < 2) {
                                  return "Email trop court !";
                                }
                                if (text.length > 100) {
                                  return "Nom trop long, Maximuin 50 !";
                                }
                              },
                              onChanged: (text) => setState(() {
                                emailControler.text = text;
                              }),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              inputFormatters: [LengthLimitingTextInputFormatter(20)],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Mot de passe ne peut pas etre vide !";
                                }
                                if (text.length < 2) {
                                  return "Entrez mot de passe valide !";
                                }
                                if (text.length > 19) {
                                  return "Mot de passe trop long, Maximuin 19 !";
                                }
                                return null;
                              }, 
                              obscureText: passToggle,
                              controller: passControler,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(
                                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                  ),
                                  labelText: "Mot de passe",
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFEDB602),
                                  ),
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passToggle = !passToggle;
                                      });
                                    },
                                    child: Icon(
                                      passToggle
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFFEDB602),
                                    ),
                                  ),
                                  border: OutlineInputBorder()),
                                

                            ),

                            TextFormField(
                              inputFormatters: [LengthLimitingTextInputFormatter(20)],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Confirmer mot de passe ne peut pas etre vide !";
                                }
                                if (text.length < 2) {
                                  return "Entrez mot de passe valide !";
                                }
                                if (text.length > 19) {
                                  return "Mot de passe trop long, Maximuin 19 !";
                                }
                                return null;
                              }, 
                              obscureText: passToggle,
                              controller: passControler,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(
                                            0xFFEDB602)), // Couleur de la bordure lorsqu'elle est désactivée
                                  ),
                                  labelText: "Mot de passe",
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                    color: Color(0xFFEDB602),
                                  ),
                                  suffix: InkWell(
                                    onTap: () {
                                      setState(() {
                                        passToggle = !passToggle;
                                      });
                                    },
                                    child: Icon(
                                      passToggle
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color(0xFFEDB602),
                                    ),
                                  ),
                                  border: OutlineInputBorder()),
                                

                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
