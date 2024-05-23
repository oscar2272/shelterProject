import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  double? latitude;
  double? longitude;

  void updateLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.denied) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ); //현재위치 받아옴
      latitude = position.latitude; //현재 위도
      longitude = position.longitude; //현재 경도
      notifyListeners();
    }
  }
}
