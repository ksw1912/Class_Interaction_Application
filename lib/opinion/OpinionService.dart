import 'package:flutter/material.dart';
import 'package:spaghetti/opinion/Opinion.dart';

class OpinionService extends ChangeNotifier {
  List<Opinion> opinionList = [];
  List<int> countList = []; //투표 인원 수

  OpinionService() {
    this.countList = List.filled(opinionList.length, 0);
  }


  void addOpinion({required Opinion opinion}) {
    this.opinionList.add(opinion);
    countList = List.filled(
        this.opinionList.length, 0); // opinion 리스트의 길이에 맞춰 count 리스트 재초기화
    notifyListeners();
  }

  void updateOpinion(int index, Opinion op) {
    opinionList[index] = op;
    countList = List.filled(this.opinionList.length, 0);
    notifyListeners();
  }

  void deleteOpinion(int index) {
    opinionList.removeAt(index);
    countList.removeAt(index);
    notifyListeners();
  }

  //투표 수량 초기화
  void updateCountList() {
    countList = List.filled(opinionList.length, 0);
  }
}
