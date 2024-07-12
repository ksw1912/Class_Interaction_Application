import 'package:flutter/material.dart';

import '../main/main.dart';

class ClassData {
  // 기존 수업 데이터
  ClassData({
    required this.content,
    required this.date,
    required this.numberStudents,
    required this.classnumber,
  });

  String content;
  String date;
  String numberStudents;
  String classnumber;
}

class ClassOpinionData {
  // 수업 생성시 옵션 데이터
  ClassOpinionData({
    required this.content,
    required this.count,
  });

  String content;
  int count;
}

class ClassService extends ChangeNotifier {
  List<ClassData> classList = [
    ClassData(
        content: '데이터베이스 A반',
        date: '최근 수업일 : 2024.03.05',
        numberStudents: '100',
        classnumber: '123452'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06',
        numberStudents: '30',
        classnumber: '123452'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 C반',
        date: '최근 수업일 : 2024.03.06',
        numberStudents: '60',
        classnumber: '123452'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 F반',
        date: '최근 수업일 : 2024.03.05',
        numberStudents: '12',
        classnumber: '123452'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06',
        numberStudents: '100',
        classnumber: '123452'), // 더미(dummy) 데이터
  ];
  List<ClassOpinionData> opinionList = [
    ClassOpinionData(content: '1', count: 10),
    ClassOpinionData(content: '2', count: 20),
    ClassOpinionData(content: '3', count: 30),
    ClassOpinionData(content: '4', count: 40),
  ];

  createOpinion({required String content, required int count}) {
    ClassOpinionData opinion = ClassOpinionData(content: content, count: count);
    opinionList.add(opinion);
    notifyListeners();
  }

  updateOpinion({required int index, required String content}) {
    ClassOpinionData opinion = opinionList[index];
    opinion.content = content;
    notifyListeners();
  }
}
