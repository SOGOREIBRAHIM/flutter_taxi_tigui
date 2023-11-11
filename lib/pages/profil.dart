import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profil extends StatefulWidget {
  const Profil({super.key});

  @override
  State<Profil> createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  List user = ["test&"];

  final emailControler = TextEditingController();

  bool desactiverCouleur = false;
  bool champModifie = false;

  void enregistrer() {
  
  String prenom = emailControler.text;
 
  print('Informations mises à jour :');
  print('Prénom : $prenom');
 
  setState(() {
    champModifie != true;
  });

  // Afficher un message ou effectuer d'autres actions après l'enregistrement
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Informations enregistrées avec succès!'),
      duration: Duration(seconds: 2),
    ),
  );
}


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    emailControler.text = user[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Pour supprimer le bouton de retour
        centerTitle: true, // Pour centrer le titre
        backgroundColor: Color(0xFFEDB602),
        elevation: 0,
        title: const Text(
          "Profil",
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
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
              child: Column(
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
            Container(
              // height: MediaQuery.sizeOf(context).height,
              // height: 300,
              width: 900,
              decoration: const BoxDecoration(
                  color: Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 16),

                          child: Column(
                            children: [

                              TextFormField(
                                controller: emailControler,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Prenom',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: MesCouleur().couleurPrincipal,
                                    )),
                                onChanged: (text) => setState(() {
                                  
                                }),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              TextFormField(

                                controller: emailControler,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Nom',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: MesCouleur().couleurPrincipal,
                                    )),
                                onChanged: (text) => setState(() {
                                  emailControler.text = emailControler.text;
                                }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              TextFormField(
                                controller: emailControler,
                                keyboardType: TextInputType.name,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Telephone',
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: MesCouleur().couleurPrincipal,
                                    )),
                                onChanged: (text) => setState(() {
                                  emailControler.text = emailControler.text;
                                  champModifie = true;
                                }),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              
                              TextButton(
                                
                                style: TextButton.styleFrom(
                                  disabledBackgroundColor: Color.fromARGB(255, 134, 133, 133),
                      
                                  textStyle: const TextStyle(fontSize: 20),
                                ),
                                
                                onPressed: champModifie ? null : () => enregistrer(), 
                                child: const Text('Enregistrer'),
                              ),
                             
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
