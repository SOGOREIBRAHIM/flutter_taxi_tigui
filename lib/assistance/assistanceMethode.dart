

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_taxi_tigui/global/global.dart';
import 'package:flutter_taxi_tigui/models/userModel.dart';

class AssistanceMethode {
  

  // Lire les information d'utilisateur actuel en ligne
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
}