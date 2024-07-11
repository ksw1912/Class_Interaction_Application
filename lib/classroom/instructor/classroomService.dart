import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:spaghetti/classroom/classroom.dart';

class ClassroomService extends ChangeNotifier {
  final String apiUrl = "https://0d3a6d00-d7ee-425d-8855-0bc4b4aaa1d0.mock.pstmn.io/classrooms";
  final storage = FlutterSecureStorage();

  List<Classroom> classroomList = [];

  Future<void> classroomCreate(
      BuildContext context, String className, List<String> ops) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    // ★★★★★★★통합테스트시 주석처리 풀어야함 ★★★★★★★★
    // if (jwt == null) {
    //   //토큰이 존재하지 않을 때 첫페이지로 이동
    //   Navigator.of(context).pushReplacementNamed('/Loginpage');
    // }

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

    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      Classroom classroom = Classroom.fromJson(responseBody);
      classroomList.add(classroom);
      notifyListeners();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('기존 수업이 존재합니다.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
