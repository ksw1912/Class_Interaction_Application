import 'package:intl/intl.dart';
import 'package:spaghetti/member/Instructor.dart';

class Classroom {
  String classId;
  String className;
  Instructor instructor;
  DateTime date;

  Classroom({
    required this.classId,
    required this.className,
    required this.instructor,
    required this.date,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() => {
        'classId': classId,
        'className': className,
        'instructor': instructor.toJson(),
        'date': DateFormat('yyyy-MM-dd').format(date), // 날짜를 yyyy-MM-dd 형식으로 변환
      };

  // JSON 역직렬화
  Classroom.fromJson(Map<String, dynamic> json)
      : classId = json['classId'],
        className = json['className'],
        instructor = Instructor.fromJson(json['instructor']),
        date = DateTime.parse(json['date']);
}
