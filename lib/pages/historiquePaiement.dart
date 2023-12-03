
import 'package:flutter/material.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/pages/accueil.dart';
import 'package:flutter_taxi_tigui/pages/paiement.dart';

class historique extends StatefulWidget {
  const historique({super.key});

  @override
  State<historique> createState() => _historiqueState();
}

class _historiqueState extends State<historique> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Historique des transactions",
          style: TextStyle(color: Color(0xFFEDB602),fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Paiement()),
              );
            },
            icon: const Icon(
              Icons.close,
              color: Color(0xFFEDB602),
              size: 30,
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20,),
              TextField(
                decoration: InputDecoration(
                  hintText: "Rechercher un paiement",
                  prefixIcon: Icon(Icons.search, color: MesCouleur().couleurPrincipal, size: 30,),
                ),
              ),
              SizedBox(height: 50,),
              Container(
                // height: MediaQuery.of(context).size.height,
                height: 260,
                width: 400,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 107, 105, 105),
                      spreadRadius: 1,
                      blurRadius: 5
                    )
                  ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("29-11-2023", style: TextStyle(color: Colors.black,fontSize: 20),),
                      SizedBox(height: 30,),
                     Row(
                      children: [
                         Image(image: AssetImage(("assets/images/cash2.png"),),color: MesCouleur().couleurPrincipal,),
                         SizedBox(width: 20,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Montant payé"),
                            Text("20.000 FCFA", style: TextStyle(fontSize: 20, color: MesCouleur().couleurPrincipal),),
                          ],
                         ),
                      ],
                     ),
                     SizedBox(height: 30,),
                      Row(
                      children: [
                         Icon(Icons.phone_android,color: MesCouleur().couleurPrincipal,size: 45,),
                         SizedBox(width: 20,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Numéro de paiement"),
                            Text("83 52 28 56", style: TextStyle(fontSize: 20, color: MesCouleur().couleurPrincipal),),
                          ],
                         ),
                      ],
                     ),
                     
                    ],
                    
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                // height: MediaQuery.of(context).size.height,
                height: 260,
                width: 400,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 107, 105, 105),
                      spreadRadius: 1,
                      blurRadius: 5
                    )
                  ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("25-11-2023", style: TextStyle(color: Colors.black,fontSize: 20),),
                      SizedBox(height: 30,),
                     Row(
                      children: [
                         Image(image: AssetImage(("assets/images/cash2.png"),),color: MesCouleur().couleurPrincipal,),
                         SizedBox(width: 20,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Montant payé"),
                            Text("20.000 FCFA", style: TextStyle(fontSize: 20, color: MesCouleur().couleurPrincipal),),
                          ],
                         ),
                      ],
                     ),
                     SizedBox(height: 30,),
                      Row(
                      children: [
                         Icon(Icons.phone_android,color: MesCouleur().couleurPrincipal,size: 45,),
                         SizedBox(width: 20,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Numéro de paiement"),
                            Text("83 52 28 56", style: TextStyle(fontSize: 20, color: MesCouleur().couleurPrincipal),),
                          ],
                         ),
                      ],
                     ),
                     
                    ],
                    
                  ),
                ),
              ),
              SizedBox(height: 40,),
              Container(
                // height: MediaQuery.of(context).size.height,
                height: 260,
                width: 400,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 107, 105, 105),
                      spreadRadius: 1,
                      blurRadius: 5
                    )
                  ],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    )),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("25-11-2023", style: TextStyle(color: Colors.black,fontSize: 20),),
                      SizedBox(height: 30,),
                     Row(
                      children: [
                         Image(image: AssetImage(("assets/images/cash2.png"),),color: MesCouleur().couleurPrincipal,),
                         SizedBox(width: 20,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Montant payé"),
                            Text("20.000 FCFA", style: TextStyle(fontSize: 20, color: MesCouleur().couleurPrincipal),),
                          ],
                         ),
                      ],
                     ),
                     SizedBox(height: 30,),
                      Row(
                      children: [
                         Icon(Icons.phone_android,color: MesCouleur().couleurPrincipal,size: 45,),
                         SizedBox(width: 20,),
                         Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Numéro de paiement"),
                            Text("83 52 28 56", style: TextStyle(fontSize: 20, color: MesCouleur().couleurPrincipal),),
                          ],
                         ),
                      ],
                     ),
                     
                    ],
                    
                  ),
                ),
              ),
            ],
          ),
        ),
        
        
      ),
    );
  }
}