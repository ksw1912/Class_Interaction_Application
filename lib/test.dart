import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class Test {
  String classId = "test";
  final storage = FlutterSecureStorage();
  String jwt =
      'Bearer eyJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImFkbWluIiwicm9sZSI6Imluc3RydWN0b3IiLCJpYXQiOjE3MjE3NDg0MDksImV4cCI6MTcyMTc1NTYwOX0.c36JkvSOghUrNejCWEqklAEM4266VcumQ60XypAG-DM';
  late StompClient stompClient;

  Test() {
    stompClient = StompClient(
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
          'Authorization': jwt,
        },
        webSocketConnectHeaders: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': jwt,
        },
      ),
    );
  }

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/classroom/$classId',
      callback: (frame) {
        print("메세지결과: $frame");
      },
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient.send(
        destination: '/app/classroom/$classId/message',
        body: json.encode({'content': 'test'}),
      );
    });
  }

  void main() {
    stompClient.activate();
  }
}

