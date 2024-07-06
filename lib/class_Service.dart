import 'package:flutter/material.dart';

import 'main.dart';

// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class ClassData {
  ClassData({
    required this.content,
    required this.date,
  });

  String content;
  String date;
}

// Memo 데이터는 모두 여기서 관리
class ClassService extends ChangeNotifier {
  List<ClassData> classList = [
    ClassData(
        content: '데이터베이스 A반 \n최근 수업일 : 2024.03.05',
        date: '최근 수업일 : 2024.03.05'), // 더미(dummy) 데이터
    ClassData(
        content: '데이라베이수 B반 \n최근 수업일 : 2024.03.06',
        date: '최근 수업일 : 2024.03.06'), // 더미(dummy) 데이터
  ];
}
