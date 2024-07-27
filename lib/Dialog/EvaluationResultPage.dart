import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/quiz/QuizService.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:spaghetti/classroom/instructor/classCreatePage.dart';

class EvaluationResultPage extends StatefulWidget {
  final Websocket? webSocket;

  EvaluationResultPage(this.webSocket, {super.key});
  @override
  _EvaluationResultPage createState() => _EvaluationResultPage();
}

class _EvaluationResultPage extends State<EvaluationResultPage> {
  String? jwt;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeJwt();
  }

  void _initializeJwt() async {
    jwt = await storage.read(key: "Authorization") ?? "";
  }

  @override
  void dispose() {
    _disposeWebSocket();
    super.dispose();
  }

  Future<void> _disposeWebSocket() async {
    if (widget.webSocket != null) {
      await widget.webSocket?.unsubscribe();
      widget.webSocket
          ?.stomClient(jwt, context)
          .deactivate(); // websocket 연결 해제
    }
    Provider.of<OpinionService>(context, listen: false).deleteAll();
  }

  @override
  Widget build(BuildContext context) {
    UserCount userCount = Provider.of<UserCount>(context, listen: false);

    // 평가 리스트를 5개의 요소로 보장
    List<int> evaluationList = List<int>.from(userCount.evaluationList);
    while (evaluationList.length < 5) {
      evaluationList.add(0);
    }

    // 계산된 평점을 바탕으로 전반적인 평가 점수를 계산합니다.
    double totalScore = 0;
    int totalReviews = 0;
    for (int i = 0; i < evaluationList.length; i++) {
      totalScore += (i + 1) * evaluationList[i];
      totalReviews += evaluationList[i];
    }
    double averageRating = totalReviews > 0 ? totalScore / totalReviews : 0;

    return Consumer<UserCount>(builder: (context, userCount, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('수업 평가'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text('평균 점수'),
                      Text(
                        averageRating.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 48,
                        ),
                      ),
                      Text(
                        '$totalReviews 명의 학생',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                _buildRatingChart(evaluationList),
                SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await widget.webSocket?.unsubscribe();
                      widget.webSocket
                          ?.stomClient(jwt, context)
                          .deactivate(); // websocket 연결 해제
                      Provider.of<OpinionService>(context, listen: false)
                          .deleteAll();
                      Provider.of<QuizService>(context,
                              listen: false) //방 삭제시 퀴즈 빠이빠이
                          .initializeQuizList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ClassCreatePage(),
                        ),
                      );
                    },
                    child: Text('확인하기'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfffbaf01),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      minimumSize: Size(double.infinity, 50), // 버튼 높이 설정
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  static Widget _buildRatingChart(List<int> evaluationList) {
    List<OpinionData> chartData = List.generate(5, (index) {
      List<Color> colors = [
        Color(0xfffcb29c),
        Color(0xfff7a3b5),
        Color(0xffa4d3fb),
        Color(0xfff5c369),
        Color(0xff7b9bcf),
      ];
      return OpinionData((index + 1).toString(),
          evaluationList[index].toDouble(), colors[index]);
    });

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: MajorGridLines(width: 0),
        axisLine: AxisLine(width: 0),
      ),
      plotAreaBorderWidth: 0,
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<OpinionData, String>>[
        BarSeries<OpinionData, String>(
          dataSource: chartData,
          xValueMapper: (OpinionData data, _) => data.opinion,
          yValueMapper: (OpinionData data, _) => data.count,
          pointColorMapper: (OpinionData data, _) => data.color,
          dataLabelSettings: DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class OpinionData {
  OpinionData(this.opinion, this.count, this.color);
  final String opinion;
  final double count;
  final Color color;
}
