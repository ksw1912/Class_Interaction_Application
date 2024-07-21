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
    countList.add(OpinionVote(opinionId: opinion.opinionId, count: 0));
    notifyListeners();
  }

  void updateOpinion(int index, Opinion op) {
    opinionList[index] = op;
    countList[index] = OpinionVote(opinionId: op.opinionId, count: 0);
    notifyListeners();
  }

  void deleteOpinion(int index) {
    opinionList.removeAt(index);
    countList.removeAt(index);
    notifyListeners();
  }
}
