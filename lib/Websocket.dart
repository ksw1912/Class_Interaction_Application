import 'dart:async';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/login/AuthService.dart';
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

  Websocket(this.classId) {
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
        print("메세지결과: $frame");
      },
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      stompClient?.send(
        destination: '/pub/classroom/$classId/message',
        body: json.encode({'content': 'test'}),
      );
    });
  }

  //연결끊기
}



