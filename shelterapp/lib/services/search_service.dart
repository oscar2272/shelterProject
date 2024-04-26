import 'dart:convert';
import 'package:shelterapp/models/shelter_area_model.dart';
import 'package:http/http.dart' as http;

class SearchService {
  static const String baseUrl = "http://127.0.0.1:8000";
  static const String region = "region";

  // 시/도 리스트 GET
  static Future<List<ShelterSearchModel>> getSido() async {
    List<ShelterSearchModel> sidoInstances = [];
    final url = Uri.parse('$baseUrl/$region/get_sido_list/');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> sidos = jsonDecode(utf8.decode(response.bodyBytes));
      for (var sido in sidos) {
        sidoInstances.add(ShelterSearchModel.fromJson(sido));
      }
      return sidoInstances;
    }
    throw Error();
  }

  // 시/군/구 GET()
  static Future<List<ShelterSearchModel>> getSigungu(String sidoName) async {
    List<ShelterSearchModel> sigunguInstances = [];
    final url =
        Uri.parse('$baseUrl/$region/get_sigungu_list/?sido_name=$sidoName');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> sigungus =
          jsonDecode(utf8.decode(response.bodyBytes));
      for (var sigungu in sigungus) {
        sigunguInstances.add(ShelterSearchModel.fromJson(sigungu));
      }
      return sigunguInstances;
    }
    throw Error();
  }
}
