
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/quiz/Quiz.dart';
import 'package:spaghetti/quiz/QuizService.dart';
import 'package:spaghetti/quiz/QuizVote.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class QuizCheckPage extends StatefulWidget {
  final Websocket? webSocket;

  const QuizCheckPage(this.webSocket, {super.key});
  @override
  _QuizCheckPage createState() => _QuizCheckPage();
}

class _QuizCheckPage extends State<QuizCheckPage> {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserCount userCount = Provider.of<UserCount>(context, listen: false);

    QuizService quizService = Provider.of<QuizService>(context, listen: false);
    List<QuizVote> quizCount = List<QuizVote>.from(quizService.quizCount);

    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    // 계산된 평점을 바탕으로 전반적인 평가 점수를 계산합니다.
    double totalScore = 0;
    int totalReviews = 0;

    double averageRating = totalReviews > 0 ? totalScore / totalReviews : 0;

    return Consumer<UserCount>(builder: (context, userCount, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text('퀴즈'),
        ),
        resizeToAvoidBottomInset: false,
        body: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              Positioned(
                left: screenWidth * 0.1,
                top: screenHeight * 0.05,
                child: SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.55, // 차트 높이 조정
                  child: BarChartExample(),
                ),
              ),
              Positioned(
                left: screenWidth * 0.1,
                top: screenHeight * 0.7,
                child: SizedBox(
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.05,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfffbaf01),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    child: Text('확인',
                        style: TextStyle(fontSize: screenWidth * 0.05)),
                  ),
                ),
              ),
            ],
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

final List<Color> contentColors = [
  // 차트 컬러 리스트
  Color(0xff7b9bcf),
  Color(0xfff5c369),
  Color(0xffa4d3fb),
  Color(0xfff7a3b5),
  Color(0xfffcb29c),
  Color(0xffcab3e7), // mainTextcolor
];

class BarChartExample extends StatefulWidget {
  const BarChartExample({super.key});

  @override
  _BarChartExampleState createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  late SortingOrder _sortingOrder;

  @override
  void initState() {
    super.initState();
    _sortingOrder = SortingOrder.ascending; // 초기 정렬 설정을 오름차순으로 변경
  }

  void _toggleSortingOrder() {
    setState(() {
      _sortingOrder = _sortingOrder == SortingOrder.ascending
          ? SortingOrder.descending
          : SortingOrder.ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        title: Text('퀴즈 차트'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _toggleSortingOrder,
          ),
        ],
      ),
      body: Consumer2<QuizService, OpinionService>(
          builder: (context, quizService, opinionService, child) {
        List<Quiz> qzList = quizService.quizList; // 옵션 배열
        List<QuizVote> qzCount = quizService.quizCount; // 옵션 선택 개수 배열

        List<QuizData> sortedData = List.generate(qzList.length, (index) {
          return QuizData(
              qzList[index].question ?? '',
              qzCount[index].count.toDouble(),
              contentColors[index % contentColors.length]);
        });

        sortedData.sort((a, b) => a.count.compareTo(b.count));
        if (_sortingOrder == SortingOrder.descending) {
          sortedData = sortedData.reversed.toList();
        }

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
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<QuizData, String>>[
            BarSeries<QuizData, String>(
              spacing: 0.2,
              dataSource: sortedData,
              xValueMapper: (QuizData data, _) => data.opinion,
              yValueMapper: (QuizData data, _) => data.count,
              pointColorMapper: (QuizData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        );
      }),
    );
  }
}

class QuizData {
  QuizData(this.opinion, this.count, this.color);
  final String opinion;
  final double count;
  final Color color;
}
