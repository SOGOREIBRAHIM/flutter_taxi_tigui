import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_taxi_tigui/config/configurationCouleur.dart';
import 'package:flutter_taxi_tigui/splashScrum/splashScrum.dart';

class PayFareAmountDialog extends StatefulWidget {
  
  double? fareAmount;

  PayFareAmountDialog({this.fareAmount});

  @override
  State<PayFareAmountDialog> createState() => _PayFareAmountDialogState();
}

class _PayFareAmountDialogState extends State<PayFareAmountDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        // margin: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: MesCouleur().couleurPrincipal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            SizedBox(height: 70,),
            Text(
              "Paiement du trajet",
            style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20,),
            Divider(
              thickness: 2,
              color: Colors.white,
              height: 2,
            ),
            SizedBox(height: 10,),
            Text(
              widget.fareAmount.toString() +" FCFA",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50,color: Colors.white),
            ),
            SizedBox(height: 20,),  
            Padding(
              padding: EdgeInsets.all(10),
              child: Text("C'est le montant total du trajet. Veuillez le payer au chauffeur ou par Orange Money",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white,fontSize: 16),
              ), 
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                ),
                 child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Montant a payer ",
                    style: TextStyle(fontSize: 18,color: MesCouleur().couleurPrincipal, fontWeight: FontWeight.bold),
                    ),
                    Text(widget.fareAmount.toString() +" FCFA",
                    style: TextStyle(fontSize: 18,color: MesCouleur().couleurPrincipal, fontWeight: FontWeight.bold),
                    ),
                  ],
                 ),
                 onPressed: (){
                  Future.delayed(Duration(milliseconds: 10000),(){
                    Navigator.pop(context, "Paiement en cash");
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> Slapsh()));
                  });
              },),
              ),
          ],
        ),
      ),
    );
  }
}