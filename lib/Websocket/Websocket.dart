import 'dart:async';
import 'dart:io';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Websocket/MessageDTO.dart';
import 'package:spaghetti/login/AuthService.dart';
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/test.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:http/http.dart' as http;
import 'package:spaghetti/ApiUrl.dart';
import 'dart:convert';

class Websocket {
  late String classId;
  final storage = FlutterSecureStorage();
  String? jwt;
  StompClient? stompClient;
  late User? user;

  Websocket(this.classId, this.user) {
    stompOn();
  }

  Future<void> stompOn() async {
    jwt = await storage.read(key: "Authorization");
    stompClient = stomClient(jwt);
    stompClient?.activate();
  }

  StompClient stomClient(String? jwt) {
    return StompClient(
      config: StompConfig.sockJS(
        url: 'http://${Apiurl().websocketUrl}/classroomEnter',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect...');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onWebSocketError: (dynamic error) => print(error.toString()),
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
    stompClient?.subscribe(
        destination: '/sub/classroom/$classId',
        callback: (frame) {
          Map<String, dynamic> json = jsonDecode(frame.body ?? "");
          MessageDTO message = MessageDTO.fromJson(json);
          switch (message.status) {
            case Status.OPINION:
              // 의견 제출 처리 로직
              if (user?.role == "instuctor") {
                // OpinionService.countList
              }
              break;
            case Status.OPINIONUPDATE:
              // 교수 의견 업데이트 처리 로직
              break;
            case Status.QUIZ:
              // 퀴즈 처리 로직
              break;
            case Status.QUIZUPDATE:
              // 교수 퀴즈 업데이트 처리 로직
              break;
            case Status.EVALUATION:
              // 수업 평가 처리 로직
              break;
            case Status.PERSIONSTATUS:
              // 사용자인원 처리 로직
              break;
            case Status.CLOSE:
              //사용자에게 수업끝났다고 알림
              break;
            default:
              break;
          }
        });

    Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient?.send(
        destination: '/pub/classroom/$classId/message',
        body: json.encode({'content': 'test'}),
      );
    });
  }

  //연결끊기
}
