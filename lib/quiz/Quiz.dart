class Quiz {
  String? quizId;
  String? classId;
  String? quiz;

  Quiz(String quizId, String classId, String quiz) {
    this.quizId = quizId;
    this.classId = classId;
    this.quiz = this.quiz;
  }

  Map<String, dynamic> toJson() =>
      {'quizId': quizId, 'classId': classId, 'quiz': quiz};

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(json['quizId'], json['classId'], json['quiz']);
  }
}
