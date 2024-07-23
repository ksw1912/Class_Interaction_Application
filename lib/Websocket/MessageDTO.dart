import 'dart:collection';

import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/quiz/Quiz.dart';

enum Status {
  OPEN,
  CLOSE,
  OPINION,
  OPINIONUPDATE,
  QUIZ,
  QUIZUPDATE,
  EVALUATION,
  PERSIONSTATUS
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
  String? classId;
  Opinion? opinion;
  Quiz? quiz;
  int? evaluation;
  Set<String> userEmails = HashSet<String>();

  MessageDTO(
    Status? status,
    String? classId,
    Opinion? opinion,
    Quiz? quiz,
    int? evaluation,
  ) {
    this.status = status;
    this.classId = classId;
    this.opinion = opinion;
    this.quiz = quiz;
    this.evaluation = evaluation;
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'classId': classId,
        'opinion': opinion,
        'quiz': quiz,
        'evaluation': evaluation,
        'userEmails': userEmails
      };
  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    return MessageDTO(json['status'], json['classId'], json['opinion'],
        json['quiz'], json['evaluation']);
  }
}
