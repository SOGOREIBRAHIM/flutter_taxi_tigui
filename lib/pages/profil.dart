import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';

class profil extends StatefulWidget {
  const profil({super.key});

  @override
  State<profil> createState() => _profilState();
}

class _profilState extends State<profil> {

  final prenomController = TextEditingController();
  final nomController = TextEditingController();
  final numeroController = TextEditingController();
  final emailController = TextEditingController();

  Future<void> showUserDialogAlert(BuildContext context, String prenom) {

    prenomController.text = prenom;

    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: Text("Modifier"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nomController,
                )
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () {
              Navigator.pop(context);
            }, 
            child: Text(
              "Annuler",
              style: TextStyle(
                color: Colors.red,
              ),
            )),

            TextButton(onPressed: () {
              Navigator.pop(context);
            }, 
            child: Text(
              "Enregistrer",
              style: TextStyle(
                color: Colors.black,
              ),
            )),
          ],
        );
      }
      );
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context);
      },
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Color(0xFFFFFFFF),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Mon profil",
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
                size: 30,
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 200,
                width: 600,
                decoration: const BoxDecoration(
                    color: Color(0xFFEBEBEB),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    )),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/1.png"),
                      radius: 50,
                      backgroundColor: Colors.white,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      'Bienvenue Chez TaxiTigui',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Container(
                  width: 600,
                  decoration:  BoxDecoration(
                      color: Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${userModelCurrentInfo!.prenom!}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                        IconButton(onPressed: () {
                          showUserDialogAlert(context, userModelCurrentInfo!.prenom!);
                          print("--------------------------------------------------------");
                          print(userModelCurrentInfo!.prenom!);
                        }, icon: Icon(Icons.edit_outlined),color: MesCouleur().couleurPrincipal,)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}