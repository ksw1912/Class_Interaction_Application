import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/quiz/Quiz.dart';
import 'package:spaghetti/quiz/QuizVote.dart';

class QuizService extends ChangeNotifier {
  List<Quiz> quizList = [];
  List<QuizVote> quizCount = [];
  final storage = FlutterSecureStorage();
  final String apiUrl = Apiurl().url;

  void setQuizList(List<Quiz>? quizs) {
    quizList = quizs ?? [];
    updateCountList();
    notifyListeners();
  }

  QuizService() {
    updateCountList();
  }

  //투표수량 초기화
  void updateCountList() {
    quizCount = quizList
        .map((quiz) => QuizVote(quizId: quiz.quizId ?? "", count: 0))
        .toList();
    notifyListeners();
  }

  //퀴즈 초기화
  void quizInit() {
    quizList.clear();
    quizCount.clear();
    notifyListeners();
  }

  void voteAdd(Quiz? quiz) {
    for (int i = 0; i < quizCount.length; i++) {
      if (quizCount[i].quizId == quiz?.quizId) {
        quizCount[i].count += 1;
        break;
      }
    }
    notifyListeners();
  }

  void addQuiz({required Quiz quiz}) {
    quizList.add(quiz);
    quizCount.add(QuizVote(quizId: "", count: 0)); // 기본 투표 수를 0으로 설정
    notifyListeners();
  }

  void initializeQuizList() {
    quizList.clear();
    quizCount.clear();
    notifyListeners();
  }

  //퀴즈 생성
  Future<void> quizCreate(BuildContext context, String classId,
      List<Quiz> quizList, Websocket? websocket) async {
    String? jwt = await storage.read(key: 'Authorization');
    if (jwt!.isEmpty) {
      //토큰이 존재하지 않을 때 첫페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return;
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': jwt,
    };
    var body = jsonEncode({
      'classId': classId,
      'quiz': quizList.map((quiz) => quiz.toJson()).toList(),
    });

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/classrooms/quiz'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        List<dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));

        List<Quiz> quizs =
            responseBody.map((json) => Quiz.fromJson(json)).toList();
        setQuizList(quizs);
        websocket?.sendQuizUpdate(quizs);
      } else {
        await Dialogs.showErrorDialog(
            context, '퀴즈 생성 실패: ${response.statusCode}');
      }
    } catch (exception) {
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }
}
