import 'package:flutter/material.dart';
import 'package:spaghetti/classroom/student/Enrollment.dart';

class EnrollmentService extends ChangeNotifier {
  List<Enrollment> enrollList = [];

  // setter
  void setEnrollList(List<Enrollment> enrollments) {
    enrollList = enrollments;
    notifyListeners();
  }

  // 새로 추가하는 메서드
  void removeEnrollment(String classId) {
    enrollList
        .removeWhere((enrollment) => enrollment.classroom.classId == classId);
    notifyListeners();
  }
}
