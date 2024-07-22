import 'package:flutter/material.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionVote.dart';

class OpinionService extends ChangeNotifier {
  List<Opinion> opinionList = [];
  List<OpinionVote> countList = []; //투표 인원 수

  OpinionService() {
    updateCountList();
  }

  // 투표 수량 초기화
  void updateCountList() {
    countList = opinionList
        .map((opinion) => OpinionVote(opinionId: opinion.opinionId, count: 0))
        .toList();
    notifyListeners();
  }

  void addOpinion({required Opinion opinion}) {
    this.opinionList.add(opinion);
    countList.add(OpinionVote(opinionId: opinion.opinionId, count: 10));
    notifyListeners();
  }

  void updateOpinion(int index, Opinion op) {
    opinionList[index] = op;
    countList[index] = OpinionVote(opinionId: op.opinionId, count: 0);
    notifyListeners();
  }

  void deleteOpinion(int index) {
    opinionList.removeAt(index);
    countList.removeAt(index); // countList에서도 해당 항목을 제거
    notifyListeners();
  }

  void deleteAll() {
    opinionList.clear();
    countList.clear();
    notifyListeners();
  }

  void initializeOpinionList() {
    opinionList.clear();
    countList.clear();
    notifyListeners();
  }

  int maxCount(List<OpinionVote> opinion) {
    int maxIndex = 0;
    for (int i = 1; i < opinion.length; i++) {
      if (opinion[i].count > opinion[maxIndex].count) {
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  void sortOpinion() {
    // 두 리스트를 연결하여 정렬하는 방법을 사용합니다.
    List<MapEntry<Opinion, OpinionVote>> combinedList = [];
    for (int i = 0; i < opinionList.length; i++) {
      combinedList.add(MapEntry(opinionList[i], countList[i]));
    }

    // count 값을 기준으로 내림차순으로 정렬합니다.
    combinedList.sort((a, b) => b.value.count.compareTo(a.value.count));

    // 정렬된 결과를 다시 각각의 리스트에 반영합니다.
    opinionList = combinedList.map((entry) => entry.key).toList();
    countList = combinedList.map((entry) => entry.value).toList();
  }
}
