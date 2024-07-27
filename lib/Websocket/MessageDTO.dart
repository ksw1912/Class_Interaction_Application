import 'dart:collection';

import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/quiz/Quiz.dart';

enum Status {
  OPEN,
  CLOSE,
  OPINION,
  OPINIONUPDATE,
  OPINIONINITIALIZE,
  QUIZ,
  QUIZUPDATE,
  EVALUATION,
  PEOPLESTATUS
  // open 사용자입장
  // close 사용자퇴장
  // opinion 의견제출하기
  // opinionupdate 교수 의견 업데이트
  // quiz 퀴즈풀기
  // quizupdate 교수 퀴즈 업데이트
  // evaluation 나가기전 수업평가
  // persionstatus 사용자인원
}

class MessageDTO {
  Status? status;
  Opinion? opinion;
  Quiz? quiz;
  int? evaluation;
  String? classId;
  List<Quiz>? quizList;
  List<Opinion>? opList;
  Set<String> userEmails = HashSet<String>();

  MessageDTO(Status? status, Opinion? opinion, Quiz? quiz, int? evaluation,
      String? classId, List<Quiz>? quizList, List<Opinion>? opList
      // Set<String> userEmails,
      ) {
    this.status = status;
    this.opinion = opinion;
    this.quiz = quiz;
    this.evaluation = evaluation;
    this.classId = classId;
    this.quizList = quizList;
    this.opList = opList;
    // this.userEmails = userEmails;
  }

  Map<String, dynamic> toJson() => {
        'status': status.toString().split('.').last as String,
        'opinion': opinion?.toJson() ?? null,
        'quiz': quiz?.toJson() ?? null,
        'evaluation': evaluation ?? null,
        'classId': classId,
      };

  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    Status status = Status.values
        .firstWhere((e) => e.toString() == 'Status.${json['status']}');
    String? classId = json['classId'];
    print("status 문제 X");
    Opinion? opinion =
        json['opinion'] != null ? Opinion.fromJson(json['opinion']) : null;
    print("의견 문제 X");
    Quiz? quiz = json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null;
    print("퀴즈 문제X");
    int? evaluation = json['evaluation'];

    List<Quiz>? quizList = json['quizList'] != null
        ? (json['quizList'] as List).map((quiz) => Quiz.fromJson(quiz)).toList()
        : null;
    print("퀴즈list 문제X");
    List<Opinion>? opList = json['opinionList'] != null
        ? (json['opinionList'] as List)
            .map((item) => Opinion.fromJson(item))
            .toList()
        : null;
    print("의견list 문제X");
    MessageDTO dto = MessageDTO(
        status, opinion, quiz, evaluation, classId, quizList, opList);
    dto.userEmails = (json['userEmails'] != null
            ? List<String>.from(json['userEmails'])
            : <String>[])
        .toSet();

    return dto;
  }
}
