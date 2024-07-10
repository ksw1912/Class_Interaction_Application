import 'package:flutter/material.dart';

import '../main/main.dart';

class ClassData {
  // 기존 수업 데이터
  ClassData({
    required this.content,
    required this.date,
    required this.numberStudents,
  });

  String content;
  String date;
  String numberStudents;
}

class ClassOpinionData {
  // 수업 생성시 옵션 데이터
  ClassOpinionData({
    required this.content,
  });

  String content;
}

// Memo 데이터는 모두 여기서 관리
class ClassService extends ChangeNotifier {
  List<ClassData> classList = [
    ClassData(
        content: '데이터베이스 A반',
        date: '최근 수업일 : 2024.03.05',
        numberStudents: '1000'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06',
        numberStudents: '30'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 C반',
        date: '최근 수업일 : 2024.03.06',
        numberStudents: '60'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 F반',
        date: '최근 수업일 : 2024.03.05',
        numberStudents: '123123'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06',
        numberStudents: '1000'), // 더미(dummy) 데이터
  ];
  List<ClassOpinionData> opinionList = [
    ClassOpinionData(content: ''),
  ];

  createOpinion({required String content}) {
    ClassOpinionData opinion = ClassOpinionData(content: content);
    opinionList.add(opinion);
    notifyListeners();
  }

  updateOpinion({required int index, required String content}) {
    ClassOpinionData opinion = opinionList[index];
    opinion.content = content;
    notifyListeners();
  }
}

class ClassOpinion extends ChangeNotifier {
  List<ClassOpinionData> opinionList = [
    ClassOpinionData(content: ''),
  ];

  createOpinion({required String content}) {
    ClassOpinionData opinion = ClassOpinionData(content: content);
    opinionList.add(opinion);
    notifyListeners();
  }

  updateOpinion({required int index, required String content}) {
    ClassOpinionData opinion = opinionList[index];
    opinion.content = content;
    notifyListeners();
  }
}
