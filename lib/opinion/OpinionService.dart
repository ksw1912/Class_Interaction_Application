import 'package:flutter/material.dart';
import 'package:spaghetti/opinion/Opinion.dart';

class OpinionService extends ChangeNotifier {
  List<Opinion> opinion = []; 
  List<int> count = []; //투표 인원 수 

  OpinionService(){
    this.count = List.filled(opinion.length, 0);
  }
  
}
