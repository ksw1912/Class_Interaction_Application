import 'package:flutter/material.dart';
import 'package:spaghetti/classroom/student/Enrollment.dart';

class EnrollmentService extends ChangeNotifier {
  List<Enrollment> enrollList = [];

  //setter
  void setEnrollList(List<Enrollment> enrollments) {
    enrollList = enrollments;
    notifyListeners();
  }
  
}
