import 'package:spaghetti/classroom/classroom.dart';

class Opinion {
  String opinionId;
  String opinion;
  Classroom classroom;

  Opinion({
    required this.opinionId,
    required this.opinion,
    required this.classroom,
  });

  Map<String, dynamic> toJson() => {
        'opinionId': opinionId,
        'opinion': opinion,
        'classroom': classroom.toJson(),
      };

  factory Opinion.fromJson(Map<String, dynamic> json) {
    return Opinion(
      opinionId: json['opinionId'],
      opinion: json['opinion'],
      classroom: Classroom.fromJson(json['classroom']),
    );
  }
}
