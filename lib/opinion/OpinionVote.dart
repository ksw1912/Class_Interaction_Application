import 'package:spaghetti/opinion/Opinion.dart';

class OpinionVote {
  String opinionId;
  int count = 0;

  OpinionVote({required String this.opinionId, int this.count = 0});
}
