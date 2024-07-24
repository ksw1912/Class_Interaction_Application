import 'package:flutter/material.dart';

class UserCount extends ChangeNotifier {
  Map<String, int> userList = Map();

  void updateUserCount(String classId, int count) {
    if (classId != "") {
      userList[classId] = count;
      notifyListeners();
    }
  }
}
