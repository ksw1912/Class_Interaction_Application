import 'package:flutter/material.dart';

import '../main/main.dart';


class ClassData {
  // 기존 수업 데이터
  ClassData({
    required this.content,
    required this.date,
  });

  String content;
  String date;
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
        date: '최근 수업일 : 2024.03.05'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.05'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반',
        date: '최근 수업일 : 2024.03.06'), // 더미(dummy) 데이터
  ];
}

class ClassOpinion extends ChangeNotifier {
  List<ClassOpinionData> opinionList = [
    ClassOpinionData(content: '데이터베이스 A반 \n최근 수업일 : 2024.03.05'),
  ];

  createOpinion({required String content}) {
    ClassOpinionData opinion = ClassOpinionData(content: content);
    opinionList.add(opinion);
    notifyListeners();
  }
}
