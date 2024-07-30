import 'package:intl/intl.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/member/Student.dart';

class Enrollment {
  String enrollmentID;
  Classroom classroom;
  Student student;
  DateTime createdAt;
  DateTime updatedAt;

  Enrollment({
    required this.enrollmentID,
    required this.classroom,
    required this.student,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'enrollmentID': enrollmentID,
        'classroom': classroom,
        'student': student,
        'createdAt': DateFormat('yyyy-MM-dd').format(createdAt),
        'updatedAt': DateFormat('yyyy-MM-dd').format(updatedAt),
      };

  factory Enrollment.notArray_fromJson(Map<String, dynamic> json) {
    return Enrollment(
      enrollmentID: json['enrollmentID'] ?? "",
      classroom: Classroom.fromJson_notArray(json['classroom']),
      student: Student.fromJson(json['student']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  factory Enrollment.fromJson(Map<String, dynamic> json) {
    // JSON 데이터에서 createdAt과 updatedAt을 List<int>로 처리
    List<int> createdAtList = List<int>.from(json['createdAt']);
    DateTime createdAt = DateTime(
      createdAtList[0], // year
      createdAtList[1], // month
      createdAtList[2], // day
      createdAtList[3], // hour
      createdAtList[4], // minute
      createdAtList[5], // second
      createdAtList[6], // microsecond
    );

    List<int> updatedAtList = List<int>.from(json['updatedAt']);
    DateTime updatedAt = DateTime(
      updatedAtList[0], // year
      updatedAtList[1], // month
      updatedAtList[2], // day
      updatedAtList[3], // hour
      updatedAtList[4], // minute
      updatedAtList[5], // second
      updatedAtList[6], // microsecond
    );

    return Enrollment(
      enrollmentID: json['enrollmentID'] ?? "",
      classroom: Classroom.fromJson(json['classroom']),
      student: Student.fromJson(json['student']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  void enrollmentDelete(int index) {}
}
