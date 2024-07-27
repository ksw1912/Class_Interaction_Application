
import 'package:spaghetti/classroom/classroom.dart';

class Quiz {
  String? quizId;
  Classroom? classroom;
  String? question;

  Quiz(String quizId, Classroom? classroom, String question) {
    this.quizId = quizId;
    this.classroom = classroom;
    this.question = question;
  }

  Map<String, dynamic> toJson() => {
        'quizId': quizId,
        'classroom': classroom?.toJson(),
        'question': question
      };

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
        json['quizId'] ?? "",
        Classroom.fromJson_notArray(json['classroom']),
        json['question'] ?? "");
  }
}
