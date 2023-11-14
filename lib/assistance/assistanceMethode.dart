

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_taxi_tigui/assistance/requsetAssistant.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/infoHandler/app_info.dart';
import 'package:flutter_taxi_tigui/models/direction.dart';
import 'package:flutter_taxi_tigui/models/userModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class AssistanceMethode {
  

  // Lire l'utilisateur actuel en ligne
  static void readCurrentOnlineInfo(){
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentUser!.uid);
      userRef.once().then((snap) =>{
        if(snap.snapshot.value != null){
          userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot)
        }
      });
  }

  static Future<String> searchAddressForGeographieCoordonnee(Position position, context) async{

    var mapKey = "AIzaSyDDGtmVxuMl8rMOacYgbdEfghp2xpOeYQg";

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAdress = "";

    var requestResponse = await RequsetAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No  Response."){
      humanReadableAdress = requestResponse["results"][0]["formatted_address"];

      Direction userPickUpAddress = Direction();
      userPickUpAddress.locationLag = position.latitude;
      userPickUpAddress.locationLong = position.longitude;
      userPickUpAddress.locationName = humanReadableAdress;
      
      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAdress(userPickUpAddress);
    }

    return humanReadableAdress;

  }
}