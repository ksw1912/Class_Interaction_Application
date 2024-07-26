import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/MessageDTO.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/quiz/Quiz.dart';
import 'package:spaghetti/quiz/QuizVote.dart';
import 'package:spaghetti/quiz/QuizVote.dart';

class QuizService extends ChangeNotifier {
  List<String> quizList = [];
  List<QuizVote> quizCount = [];
  final storage = FlutterSecureStorage();
  final String apiUrl = Apiurl().url;

  void setQuizList(List<String> quizs) {
    quizList = quizs;
    notifyListeners();
  }

  //퀴즈 초기화
  void quizInit() {
    quizList.clear();
    notifyListeners();
  }

  void addQuiz({required String quiz}) {
    this.quizList.add(quiz);
    quizCount.add(QuizVote(quizId: "", count: 0)); // 기본 투표 수를 0으로 설정
    notifyListeners();
  }

  //퀴즈 생성
  Future<void> quizCreate(BuildContext context, String classId,
      List<Quiz> quizList, Websocket websocket) async {
    if (quizList.isEmpty) {
      await Dialogs.showErrorDialog(context, '내용을 입력해주세요.');
    }
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt!.isEmpty) {
      //토큰이 존재하지 않을 때 첫페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return;
    }
    var quizListJson = quizList.map((quiz) => quiz.toJson()).toList();

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${jwt}',
    };
    var body = jsonEncode({
      'classId': classId,
      'question': quizListJson,
    });

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/classrooms/quiz'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<Quiz> quizs = (responseBody['quiz'] as List)
            .map((json) => Quiz.fromJson(json))
            .toList();
        //setQuizList(quizs);
        websocket.sendQuizUpdate(quizs);
      } else {
        await Dialogs.showErrorDialog(
            context, '퀴즈 생성 실패: ${response.statusCode}');
      }

      print(response.statusCode);
    } catch (exception) {
      print(exception);
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }
}
