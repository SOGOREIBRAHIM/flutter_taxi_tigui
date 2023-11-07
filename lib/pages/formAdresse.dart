import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/vehicule.dart';
import 'package:flutter_taxi_tigui/widgets/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';

class FormAdresse extends StatefulWidget {
  const FormAdresse({super.key});

  @override
  State<FormAdresse> createState() => _FormAdresseState();
}

class _FormAdresseState extends State<FormAdresse> {
  Future<String> showGoogleAutoCompl() async {
    const apiKey = "AIzaSyDDGtmVxuMl8rMOacYgbdEfghp2xpOeYQg";

    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: apiKey,
      mode: Mode.overlay,
      language: "fr",
      region: "ML",
      components: [Component(Component.country, "ML")],
      types: ["(cities)"],
      hint: "Chercher une adresse",
    );

    if (p != null) {
      // Faites quelque chose avec la prédiction
      print(p.description);
    }

    return p!.description!;
  }

  TextEditingController departController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  // etat du champs
  bool showSourceField = false;
  bool showSourceField2 = false;

  void goVehicule(){
    if(departController.text.isNotEmpty && destinationController.text.isNotEmpty){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Vehicule()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        title: const Text(
          "Choisissez votre destination",
          style: TextStyle(color: Color(0xFFEDB602)),
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
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextFormField(
                readOnly: true,
                controller: departController,
                onTap: () async {
                  // recuperer l'adresse selectionner
                  String selectedPlace = await showGoogleAutoCompl();
                  departController.text = selectedPlace;
                  setState(() {
                    showSourceField = true;
                  });
                },
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Choisir un point de depart',
                    prefixIcon: Icon(
                      Icons.location_on_outlined,
                      color: Color(0xFFEDB602),
                      size: 32,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: TextFormField(
                readOnly: true,
                controller: destinationController,
                onTap: () async {
                  // recuperer l'adresse selectionner
                  String selectedPlace = await showGoogleAutoCompl();
                  destinationController.text = selectedPlace;
                  setState(() {
                    showSourceField2 = true;
                  });
                  goVehicule();
                },
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Choisir une destination',
                    prefixIcon: Icon(
                      FontAwesomeIcons.circleDot,
                      color: Color(0xFFEDB602),
                    )),
              ),
            ),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
              child: Row(
                children: [
                  Icon(FontAwesomeIcons.location, color: Color(0xFFEDB602)),
                  SizedBox(width: 20),
                  Text("Votre position actuelle"),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 180),
              child: Container(
                child: Image(image: AssetImage("assets/images/33.png")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
