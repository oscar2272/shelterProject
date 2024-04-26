import 'dart:convert';

import 'package:shelterapp/models/shelter_model.dart';
import 'package:http/http.dart' as http;

class ShelterService {
  final String? sidoName, sigunguName;

  static const String baseUrl = "http://127.0.0.1:8000";
  static const String shelter = "shelter";

  ShelterService({
    required this.sidoName,
    required this.sigunguName,
  });

  //대피소 리스트
  static Future<List<ShelterModel>> getShelters(
      {String? sidoName, String? sigunguName}) async {
    List<ShelterModel> sheltersInstance = [];
    final url = Uri.parse(
        '$baseUrl/$shelter/search?sido_name=$sidoName&sigungu_name=$sigunguName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> shelters =
          jsonDecode(utf8.decode(response.bodyBytes));
      for (var shelter in shelters) {
        sheltersInstance.add(ShelterModel.fromJson(shelter));
      }
      return sheltersInstance;
    }
    throw Error();
  }
}
