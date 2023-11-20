import 'package:flutter_taxi_tigui/models/active_nearby_availablewhen_driver.dart';

class GeofireAssistance {
  static List<ActiveNearbyAvailableDriver> activeNearbyAvailableDriverList = [];

  static void deleteOffLineDriverFromList(String driverId){
    int indexNumber = activeNearbyAvailableDriverList.indexWhere((element) => element.driverId == driverId);
    activeNearbyAvailableDriverList.removeAt(indexNumber);
  }

  static void updateActiveNearbyAvailableDriverLocation(ActiveNearbyAvailableDriver driverWhoMove){
    int indexNumber = activeNearbyAvailableDriverList.indexWhere((element) => element.driverId == driverWhoMove.driverId);

    activeNearbyAvailableDriverList[indexNumber].locationLatitude = driverWhoMove.locationLatitude;
    activeNearbyAvailableDriverList[indexNumber].locationLongitude = driverWhoMove.locationLongitude;

  }
}