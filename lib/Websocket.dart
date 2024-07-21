import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:http/http.dart' as http;
import 'package:spaghetti/ApiUrl.dart';
import 'dart:convert';

class Websocket {
  StompClient? stompClient;
  late String classId;
  final storage = FlutterSecureStorage();
  String jwt = '';

  Websocket(this.classId) {
    _initializeWebSocket();
  }

  Future<void> _initializeWebSocket() async {
    jwt = (await storage.read(key: 'Authorization')) ?? '';
    print('waiting to connect..');
    await Future.delayed(const Duration(milliseconds: 200));
    print('connecting...');

    stompClient = StompClient(
      config: StompConfig.sockJS(
        url: 'http://${Apiurl().websocketUrl}/classroomEnter',
        onConnect: onConnect,
        beforeConnect: () async {
          print('waiting to connect..');
          await Future.delayed(const Duration(milliseconds: 200));
          print('connecting...');
        },
        onStompError: (dynamic error) => print('Stomp Error: $error'),
        onWebSocketError: (dynamic error) =>
            print("에러메세지: " + error.toString()),
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
    print("$jwt");
  }

  void onConnect(StompFrame frame) {
    print('Connected to WebSocket');
    //도착
    stompClient?.subscribe(
      destination: '/topic/classroom/$classId',
      callback: (frame) {
        print("결과 내용 $frame");
        Map<String, dynamic> opinion = jsonDecode(frame.body!);

        // List<dynamic>? result = json.decode(frame.body!);
        print('Received message: $opinion');
      },
    );
    //퀴즈 받기
    stompClient?.subscribe(
        destination: '/topic/classroom/$classId/quiz/select',
        callback: (frame) {});
    //퀴즈 생성 데이터 보내기
    stompClient?.send(
      destination: '/app/classroom/$classId/quiz/create',
      body: json.encode({'content': "text"}),
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      //메세지 보냄10초마다
      stompClient?.send(
        destination: '${Apiurl().websocketUrl}/app/classroom/$classId/message',
        body: json.encode({'content': "text"}),
      );
    });
  }
}
