import 'dart:convert';

import 'package:flutter_session_jwt/flutter_session_jwt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  //url 주소
  final String apiUrl = "https://your-api-url.com/login";
  final storage = new FlutterSecureStorage();

  Future<http.Response> login(String email, String password) async {
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      // response.body를 JSON으로 파싱하여 토큰 추출
      var responseBody = jsonDecode(response.body);
      var token = responseBody['token'];

      // FlutterSecureStorage에 토큰 저장
      await storage.write(key: 'jwt_token', value: token);
    }
    return response;
  }

  Future<void> logout() async {
    // FlutterSecureStorage에서 토큰 삭제
    await storage.delete(key: 'jwt_token');
  }
}
