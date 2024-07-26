import 'package:spaghetti/opinion/Opinion.dart';

class QuizVote {
  String quizId;
  int count = 0;

  QuizVote({required String this.quizId, int this.count = 0});
}
