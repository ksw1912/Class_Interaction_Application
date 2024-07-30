import 'package:flutter/material.dart';

class UserCount extends ChangeNotifier {
  Map<String, int> userList = {};
  List<int> evaluationList = [0, 0, 0, 0, 0];

  void updateUserCount(String classId, int count) {
    if (classId != "") {
      userList[classId] = count;
      notifyListeners();
    }
  }

  void evaluationListAdd(int? i) {
    if (i != null) {
      evaluationList[i] += 1;
    }
    notifyListeners();
  }

  // int? getEval() {
  //   int a = 0;
  //   int index;
  //   for (int i = 0; i < evaluationList.length; i++) {
  //     if (a <= evaluationList[i]) {
  //       a = evaluationList[i];
  //       index = i;
  //     }
  //   }
  //   if (a != 0) {
  //     return a;
  //   }
  //   return null;
  // }

  // int? getIndexEval() {
  //   int a = 0;
  //   int index = 0;
  //   for (int i = 0; i < evaluationList.length; i++) {
  //     if (a <= evaluationList[i]) {
  //       a = evaluationList[i];
  //       index = i;
  //     }
  //   }
  //   if (a != 0) {
  //     return index;
  //   }
  //   return null;
  // }

  int getSum() {
    return evaluationList.fold(0, (prev, element) => prev + element);
  }
}
