import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:spaghetti/classroom/classroom.dart';

class ClassOpinionData {
  // 수업 생성시 옵션 데이터
  ClassOpinionData({
    required this.content,
    required this.count,
  });

  String content;
  int count;
}

class ClassroomService extends ChangeNotifier {
  final String apiUrl = Apiurl().url;
  final storage = FlutterSecureStorage();

  List<Classroom> classroomList = [];

  List<ClassOpinionData> opinionList = [
    ClassOpinionData(content: '20', count: 20),
    ClassOpinionData(content: '30', count: 30),
    ClassOpinionData(content: '100', count: 100),
    ClassOpinionData(content: '40', count: 40),
  ];

  createOpinion({required String content, required int count}) {
    ClassOpinionData opinion = ClassOpinionData(content: content, count: count);
    opinionList.add(opinion);
    notifyListeners();
  }

  updateOpinion({required int index, required String content}) {
    ClassOpinionData opinion = opinionList[index];
    opinion.content = content;
    notifyListeners();
  }

  deleteOpinion({required int index}) {
    opinionList.removeAt(index);
    notifyListeners();
  }

  int maxCount(List<ClassOpinionData> opinion) {
    int maxIndex = 0;
    for (int i = 1; i < opinion.length; i++) {
      if (opinion[i].count > opinion[maxIndex].count) {
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  //@controller("/classrooms")
  Future<void> classroomCreate(
      BuildContext context, String className, List<String> ops) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    // ★★★★★★★통합테스트시 주석처리 풀어야함(+토큰 주석풀어줘야함) ★★★★★★★★
    // if (jwt == null) {
    //   //토큰이 존재하지 않을 때 첫페이지로 이동
    //   Navigator.of(context).pushReplacementNamed('/Loginpage');
    // }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      // 'Authorization': 'Bearer $jwt',
    };

    var body = jsonEncode({
      'className': className,
      'ops': ops,
    });
    try {
      var response = await http.post(
        Uri.parse('${apiUrl}/classrooms'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        Classroom classroom = Classroom.fromJson(responseBody);
        print(
            "classId: ${classroom.classId},className: ${classroom.className}, ${classroom.date}");
        classroomList.add(classroom);
        notifyListeners();
      } else {
        _showErrorDialog(context, '기존 수업이 존재합니다.');
      }
    } catch (exception) {
      _showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  Future<dynamic> _showErrorDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
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

  //날짜 string 타입으로변환
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
