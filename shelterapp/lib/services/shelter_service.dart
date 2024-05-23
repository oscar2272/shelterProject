import 'dart:convert';
import 'dart:io';

import 'package:shelterapp/models/shelter_model.dart';
import 'package:http/http.dart' as http;

class ShelterService {
  static const String baseUrl = "http://127.0.0.1:8000";
  static const String shelter = "shelter";

  //대피소 리스트
  static Future<List<ShelterModel>> getShelters({
    String? sidoName,
    String? sigunguName,
    double? latitude,
    double? longitude,
  }) async {
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

  static Future<ShelterModel> getShelterById(int shelterId) async {
    final url = Uri.parse('$baseUrl/$shelter/$shelterId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final shelter = jsonDecode(utf8.decode(response.bodyBytes));
      return ShelterModel.fromJson(shelter);
    }
    throw Error();
  }

  static Future<void> addShelterCapacityCount(int shelterId, int userId) async {
    final url = Uri.parse('$baseUrl/shelter/$shelterId/add_capacity');
    final csrfToken = await _fetchCSRFTokenFromServer();

    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode({'userId': userId}),
    );

    // 응답 확인
    if (response.statusCode == 201) {
      return;
    } else {
      throw Error();
    }
  }

  static Future<void> subtractShelterCapacityCount(
      int shelterId, int userId) async {
    final url = Uri.parse('$baseUrl/shelter/$shelterId/subtract_capacity');

    // CSRF 토큰 가져오기
    final csrfToken = await _fetchCSRFTokenFromServer();

    // HTTP 요청 헤더 구성
    var headers = {
      HttpHeaders.refererHeader: "http://127.0.0.1:8000",
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.cookieHeader: "csrftoken=$csrfToken",
      'X-CSRFToken': csrfToken,
    };

    // PUT 요청 보내기
    final response = await http.put(
      url,
      headers: headers,
      body: jsonEncode({'shelter_id': shelterId, 'userId': userId}),
    );

    // 응답 확인
    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception('Failed to subtract shelter capacity');
    }
  }

  static Future<String> _fetchCSRFTokenFromServer() async {
    // 서버에서 CSRF 토큰 가져오기
    final response = await http.get(Uri.parse('$baseUrl/get_csrf_token'));

    // 응답 확인 및 CSRF 토큰 추출
    if (response.statusCode == 200) {
      // 서버 응답에서 CSRF 토큰을 추출
      final csrfToken = json.decode(response.body)['csrf_token'];
      return csrfToken;
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }
}
