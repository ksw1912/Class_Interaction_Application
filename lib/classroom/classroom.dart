import 'package:spaghetti/member/Instructor.dart';

class Classroom {
  String classId;
  String className;
  Instructor instructor;
  DateTime? createdAt;
  DateTime? updatedAt;

  Classroom({
    required this.classId,
    required this.className,
    required this.instructor,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
        'classId': classId,
        'className': className,
        'instructor': instructor.toJson(),
        'createdAt': null, // 날짜를 yyyy-MM-dd 형식으로 변환
        'updatedAt': null
      };

  //classroom 생성 response할때  생성한 정보(날짜)들이 배열로 받기 때문에 생성할때만 사용하고 이외에는 아래 Classroom.fromJson_notArray 메소드를 사용
  factory Classroom.fromJson(Map<String, dynamic> json) {
    // JSON 배열 형식의 날짜를 파싱하여 DateTime 객체로 변환
    List<int> createdAtList = List<int>.from(json['createdAt']);
    DateTime createdAt = DateTime(
      createdAtList[0], // year
      createdAtList[1], // month
      createdAtList[2], // day
    );

    List<int> updatedAtList = List<int>.from(json['updatedAt']);
    DateTime updatedAt = DateTime(
      updatedAtList[0], // year
      updatedAtList[1], // month
      updatedAtList[2], // day
    );

    return Classroom(
      classId: json['classId'],
      className: json['className'],
      instructor: Instructor.fromJson(json['instructor']),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
  factory Classroom.fromJson_notArray(Map<String, dynamic> json) {
    return Classroom(
      classId: json['classId'],
      className: json['className'],
      instructor: Instructor.fromJson(json['instructor']),
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
