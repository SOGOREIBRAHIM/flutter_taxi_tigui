import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/assistance/requsetAssistant.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/models/predictionPlace.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/vehicule.dart';
import 'package:flutter_taxi_tigui/widgets/home.dart';
import 'package:flutter_taxi_tigui/widgets/predictionPlaceDesign.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class FormAdresse extends StatefulWidget {
  const FormAdresse({super.key});

  @override
  State<FormAdresse> createState() => _FormAdresseState();
}

class _FormAdresseState extends State<FormAdresse> {

  // TextEditingController departController = TextEditingController();
  // TextEditingController destinationController = TextEditingController();

  // // etat du champs
  // bool showSourceField = false;
  // bool showSourceField2 = false;

  // void goVehicule(){
  //   if(departController.text.isNotEmpty && destinationController.text.isNotEmpty){
  //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Vehicule()));
  //   }
  // }

  List<PredictionPlacle> predictionPlacesList = [];

  findPlaceAutoCompletSearch(String inputText) async{
    if (inputText.length > 1) {
      var mapKey = "AIzaSyDDGtmVxuMl8rMOacYgbdEfghp2xpOeYQg";
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:ML";
       
       var responseAutoCompleteSearch = await RequsetAssistant.receiveRequest(urlAutoCompleteSearch);
       
       if (responseAutoCompleteSearch == "Error Occured. Failed. No Response.") {
         return;
       }

       if (responseAutoCompleteSearch["status"] == "OK") {
         var placePrediction = responseAutoCompleteSearch["predictions"];
         var predictionPlaceList = (placePrediction as List).map((jsonData) => PredictionPlacle.fromJson(jsonData)).toList();
         setState(() {
           predictionPlacesList = predictionPlaceList;
         });
       }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          title:  Text(
            "Où voulez-vous aller ?",
            style: TextStyle(color: MesCouleur().couleurPrincipal ,fontWeight: FontWeight.bold,fontSize: 25),

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
          child: Align(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: TextFormField(
                    // controller: destinationController,
                    onChanged: (value) {
                      print(value);
                      debugPrint(value.toString());
                      findPlaceAutoCompletSearch(value);
                    },
                    decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Choisir un point de depart',
                        prefixIcon: Icon(
                          FontAwesomeIcons.circleDot,
                          color: Color(0xFFEDB602),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                  child: TextFormField(
                    // controller: destinationController,
                    onChanged: (value) {
                      print(value);
                      debugPrint(value.toString());
                      findPlaceAutoCompletSearch(value);
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
                // const Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                //   child: Row(
                //     children: [
                //       // ignore: deprecated_member_use
                //       Icon(FontAwesomeIcons.location, color: Color(0xFFEDB602)),
                //       SizedBox(width: 20),
                //       Text("Votre position actuelle"),
                //     ],
                //   ),
                // ),
          
               SizedBox(
                height: 220,
                // height: MediaQuery.sizeOf(context).height,
                child:  // la liste des resultat de google Maps
                (predictionPlacesList.length > 0)
                ? ListView.separated(
                  shrinkWrap: true,
                  itemCount: predictionPlacesList.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return PredictionPlaceDesign(
                      predictionPlacle: predictionPlacesList[index],
                    );
                  },
                  separatorBuilder:(BuildContext context, int index){
                    return Divider(
                      height: 0,
                      color: MesCouleur().couleurPrincipal,
                    );
                  },
                ) : Container(),
               ),
               Padding(
                  padding:
                      const EdgeInsets.only(top: 1),
                  child: Container(
                    child: Image(image: AssetImage("assets/images/33.png")),
                  ),
                ),
              ],
          
            ),
            
          ),
        ),
      ),
    );
  }
}
