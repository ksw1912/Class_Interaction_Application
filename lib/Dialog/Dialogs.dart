import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dialogs {
  static Future<dynamic> showErrorDialog(BuildContext context, String message) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<dynamic> showEvaluationDialog(
      BuildContext context, Websocket websocket) {
    int selectedRating = 0;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        double screenWidth = MediaQuery.of(context).size.width;
        double circlePadding = screenWidth * 0.005; // 화면 너비의 2%만큼 간격 설정

        return AlertDialog(
          backgroundColor: Colors.white, // 모달 배경을 화이트로 설정
          contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          title: Column(
            children: [
              Text(
                '공학 개념의 이해',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                '강의를 평가해주세요.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (index) {
                  int ratingValue = (index + 1);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: circlePadding),
                    child: GestureDetector(
                      onTap: () {
                        selectedRating = ratingValue;
                        (context as Element)
                            .markNeedsBuild(); // Rebuild to update UI
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xfffbaf01),
                            width: 1,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundColor: selectedRating == ratingValue
                              ? Color(0xfffbaf01)
                              : Colors.white,
                          child: Text(
                            '$ratingValue',
                            style: TextStyle(
                              color: selectedRating == ratingValue
                                  ? Colors.white
                                  : Color(0xfffbaf01),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    websocket.studentEvaluation(selectedRating);
                    Navigator.of(context).pop();
                  },
                  child: Text('평가하기'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffbaf01),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> showInstructorDialogEval(BuildContext context) {
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

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Column(
            children: [
              Text('Overall Rating'),
              Text(
                averageRating.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    color:
                        index < averageRating ? Color(0xfffbaf01) : Colors.grey,
                  );
                }),
              ),
              Text(
                'Based on $totalReviews reviews',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildRatingRow('Excellent', evaluationList[4], totalReviews),
                _buildRatingRow('Good', evaluationList[3], totalReviews),
                _buildRatingRow('Average', evaluationList[2], totalReviews),
                _buildRatingRow('Poor', evaluationList[1], totalReviews),
                _buildRatingRow('Terrible', evaluationList[0], totalReviews),
                SizedBox(height: 16),
                _buildRatingChart(evaluationList),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Widget _buildRatingRow(String label, int count, int totalReviews) {
    double percentage = totalReviews > 0 ? count / totalReviews : 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label)),
          Expanded(
            flex: 8,
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey[300],
              color: Color(0xfffbaf01),
            ),
          ),
          SizedBox(width: 8),
          Text('${(percentage * 100).toStringAsFixed(0)}%'),
        ],
      ),
    );
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
