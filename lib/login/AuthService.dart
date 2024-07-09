import 'dart:convert';

import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  //url 주소
  final String apiUrl = "http://192.168.123.172:8080/login";
  final storage = new FlutterSecureStorage();

  Future<http.Response> login(
      String email, String password, String role) async {
    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'email': email,
            'password': password,
          },
        ),
      );

      if (response.statusCode == 200) {
        // response.body를 JSON으로 파싱하여 토큰 추출
        var responseBody = jsonDecode(response.body);
        var token = responseBody['token'];
        print("$email , $password");
        // FlutterSecureStorage에 토큰 저장
        await storage.write(key: 'jwt_token', value: token);
      } else {
        print(response.statusCode);
      }
      return response;
    } catch (e) {
      print("$e");
      return http.Response('Error 발생', 500);
    }
  }

  Future<void> logout() async {
    // FlutterSecureStorage에서 토큰 삭제
    await storage.delete(key: 'jwt_token');
  }
}
