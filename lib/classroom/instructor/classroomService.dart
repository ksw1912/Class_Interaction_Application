import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ClassroomService {
  final String apiUrl = "http://192.168.123.172:8080/classrooms";
  final storage = FlutterSecureStorage();

  Future<http.Response> classroomCreate(
      String className, List<String> ops) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt == null) {
      print("첫페이지로 이동"); //누가 예외처리좀해줘~~~~(jwt소멸되어서 첫페이지로 이동해야하는 상황)
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $jwt',
    };

    var body = jsonEncode({
      'className': className,
      'ops': ops,
    });

    var response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: body,
    );

    return response;
  }
}
