import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shelterapp/models/user.dart';
import 'package:shelterapp/screens/home_screen.dart';

class UserController with ChangeNotifier {
  static const String baseUrl = "http://127.0.0.1:8000";

  User? _user;
  User? get user => _user;
  int? shelterId;
  int? userId;
  String? username;
  Future<void> fetchUserData() async {
    try {
      final url = Uri.parse('$baseUrl/user/data');
      SharedPreferences? prefs = await SharedPreferences.getInstance();
      String? sessionId = prefs.getString('session_id');
      print("fetchUserData sessionid: $sessionId");
      final response =
          await http.get(url, headers: {'Authorization': 'Session $sessionId'});

      if (response.statusCode == 200) {
        final responseData = jsonDecode(utf8.decode(response.bodyBytes));
        _user = User.fromJson(responseData);
        shelterId = _user?.shelterId;
        userId = _user?.userId;
        username = _user?.name;
        notifyListeners();
      } else {
        throw Exception('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  static Future<String> loginWithKakao() async {
    final url = Uri.parse('$baseUrl/user/kakao');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseData = response.body;
      print("Response data: $responseData"); // 응답 데이터 출력
      return responseData; // Return the URL directl
    } else {
      // 필요한 경우 다른 상태 코드를 처리합니다
      throw Exception('카카오 로그인 URL을 가져오지 못했습니다: ${response.statusCode}');
    }
  }

  Future<void> logout(BuildContext context) async {
    final url = Uri.parse('$baseUrl/user/logout');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print('Logged out successfully');
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print('Logout failed');
    }
  }
}
