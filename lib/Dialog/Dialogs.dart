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
      BuildContext context, Websocket websocket, String className) {
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
              Text(className,
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
                  int ratingValue = index + 1;
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
                    websocket.studentEvaluation(selectedRating - 1);
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xfffbaf01),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: Text('평가하기'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
