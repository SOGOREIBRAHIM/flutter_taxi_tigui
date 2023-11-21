
import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_taxi_tigui/assistance/requsetAssistant.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/infoHandler/app_info.dart';
import 'package:flutter_taxi_tigui/models/direction.dart';
import 'package:flutter_taxi_tigui/models/directionDetailsInfo.dart';
import 'package:flutter_taxi_tigui/models/userModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;


class AssistanceMethode {
  

  // Lire l'utilisateur actuel en ligne
  static Future<void> readCurrentOnlineInfo()async{
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentUser!.uid);
    
      final snap = await userRef.once();
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
  }

  static Future<String> searchAddressForGeographieCoordonnee(Position position, context) async{

    var mapKey = "AIzaSyDDGtmVxuMl8rMOacYgbdEfghp2xpOeYQg";

    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadableAdress = "";

    var requestResponse = await RequsetAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occured. Failed. No  Response."){
      humanReadableAdress = requestResponse["results"][0]["formatted_address"];

      Direction userPickUpAddress = Direction();
      userPickUpAddress.locationLagitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAdress;
      
      Provider.of<AppInfo>(context, listen: false).updatePickupLocationAdress(userPickUpAddress);
    }

    return humanReadableAdress;

  }

  static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition) async{
    
    var mapKey = "AIzaSyDDGtmVxuMl8rMOacYgbdEfghp2xpOeYQg";

    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequsetAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    // if(responseDirectionApi == "Error Occured. Failed. No  Response.") {
    //   return;
    // }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];
    
    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];
    
    return directionDetailsInfo;
  }

  // Calculer le montant du tarif entre la position et le destination
  static double calculFareAmountFromOriginToDestination(DirectionDetailsInfo directionDetailsInfo){
    double timeTravelledFareAmountPerMinute = (directionDetailsInfo.duration_value!/60)*0.1;
    double distanceTravelleAmountPerKilometre = (directionDetailsInfo.distance_value!/1000)*0.1;

    double totalFareAmount = timeTravelledFareAmountPerMinute + distanceTravelleAmountPerKilometre;
    int totalFareAmountAsInt = totalFareAmount.toInt();
    return double.parse(totalFareAmountAsInt.toStringAsFixed(1));
  }

  static sendNotificationToDriverNow(String deviceRegistrationToken, String userRideRequestId, context) async{
    String destinationAdress = userDropOffAdress;

    Map<String,String> headerNotification ={
        'Conetent-type': 'application/json',
        'Autorization': cloudMessagingServerToken,
    };

     Map bodyNotification = {
      "body": "Destination Address: \n $destinationAdress",
      "title": "Nouvelle demande de reservation"
    };

    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };

    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken,
    };

    var responseNotification = http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat)
    );
  }
}