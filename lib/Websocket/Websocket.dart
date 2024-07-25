import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/MessageDTO.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'dart:convert';

class Websocket {
  late String classId;
  final storage = FlutterSecureStorage();
  String? jwt;
  StompClient? stompClient;
  late User? user;
  dynamic unsubscribe;
  final UserCount userCount;
  // late BuildContext context;
  Websocket(this.classId, this.user, this.userCount, this.jwt) {
    stompClient = stomClient(jwt);
    stompClient?.activate();
  }

  StompClient stomClient(String? jwt) {
    return StompClient(
      config: StompConfig.sockJS(
        url: '${Apiurl().url}/classroomEnter',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 2000));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
        onDisconnect: (frame) {},
        reconnectDelay: const Duration(milliseconds: 0),
        stompConnectHeaders: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwt ?? "",
        },
        webSocketConnectHeaders: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwt,
        },
      ),
    );
  }

  void onConnect(StompFrame frame) {
    unsubscribe = stompClient!.subscribe(
      destination: '/sub/classroom/$classId',
      callback: (frame) {
        Map<String, dynamic> json = jsonDecode(frame.body ?? "");
        MessageDTO message = MessageDTO.fromJson(json);
        switch (message.status) {
          case Status.OPINION:
            // 의견 제출 처리
            if (user?.role == "instructor") {
              // OpinionService.countList
            }
            break;
          case Status.OPINIONUPDATE:
            // 교수 의견 업데이트 처리
            break;
          case Status.QUIZ:
            // 퀴즈 처리
            break;
          case Status.QUIZUPDATE:
            // 교수 퀴즈 업데이트 처리
            break;
          case Status.EVALUATION:
            // 수업 평가 처리
            break;
          case Status.PEOPLESTATUS:
            // 사용자인원 처리
            print("사용자인원 제공: ${message.userEmails.length}");
            userCount.updateUserCount(
                message.classId ?? "", message.userEmails.length);
            break;
          case Status.CLOSE:
            print("교수님께서 수업을 종료하셨습니다");
            //사용자에게 수업끝났다고 알림
            // Dialogs.showErrorDialog(context, "교수님께서 수업을 종료하셨습니다 ");
            // Navigator.pop(context);
            break;
          default:
            print("예외문제 확인용(default switch문) ${message.status}");
            break;
        }
      },
    );
  }

  //의견 보내기
  void opinionSend(Opinion opinion) {
    stompClient?.send(
      destination: '/pub/classroom/$classId/message',
      body: json.encode({
        'status': Status.OPINION,
        'classId': classId,
        'opinion': opinion,
      }),
    );
  }

  //의견 수정 정보 알리기
  void sendOpinionUpdate() {
    stompClient?.send(
      destination: '/pub/classroom/$classId/message',
      body: json.encode({
        'status': Status.OPINIONUPDATE,
        'classId': classId,
      }),
    );
  }

  //학생들에게 퀴즈 풀기 알리기
  void sendQuizUpdate() {
    stompClient?.send(
      destination: '/pub/classroom/$classId/message',
      body: json.encode({
        'status': Status.QUIZ,
        'classId': classId,
      }),
    );
  }

  //학생 -> 교육자 평가
  void studentEvaluation() {
    stompClient?.send(
      destination: '/pub/classroom/$classId/message',
      body: json.encode({
        'status': Status.QUIZ,
        'classId': classId,
      }),
    );
  }
}
//   //연결끊기
//   void disconnect() {
//     try {
//       unsubscribe(); // 구독 취소
//       stompClient?.deactivate();
//       print('연결 끊기 완료');
//     } catch (e) {
//       print('연결 끊기 실패: $e');
//     }
//   }
// }

// unsubscribeFn(unsubscribeHeaders: {});
// client.deactivate();

