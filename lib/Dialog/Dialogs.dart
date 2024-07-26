import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';

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
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('오늘의 수업 어떠셨나요?'),
          content: Row(
            children: [
              TextButton(
                child: Text(
                  '😭',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  websocket.studentEvaluation(0);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  '😐',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  websocket.studentEvaluation(1);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  '😊',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  websocket.studentEvaluation(2);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(
                  '😍',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                onPressed: () {
                  websocket.studentEvaluation(3);
                  Navigator.of(context).pop();
                },
              ),
              // TextButton(
              //   child: Text('OK'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  static Future<dynamic> showInstructorDialogEval(BuildContext context) {
    UserCount userCount = Provider.of<UserCount>(context, listen: false);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('수업평가인원: ${userCount.getSum()}명'),
          content: Row(
            children: [
              Text('😭: ${userCount.evaluationList[0]}'),
              Text('😐: ${userCount.evaluationList[1]}'),
              Text('😊: ${userCount.evaluationList[2]}'),
              Text('😍: ${userCount.evaluationList[3]}'),
            ],
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
}
