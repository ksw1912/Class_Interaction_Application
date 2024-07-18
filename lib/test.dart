import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class Test {
  String classId = "test";
  final storage = FlutterSecureStorage();
  String jwt = '';
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
          'Authorization': '${jwt}',
        },
        webSocketConnectHeaders: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': '${jwt}',
        },
      ),
    );
  }

  void onConnect(StompFrame frame) {
    stompClient.subscribe(
      destination: '/topic/classroom/$classId',
      callback: (frame) {
        print("메세지결과: $frame");
        List<dynamic>? result = json.decode(frame.body!);
        print(result);
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

void main() {
  Test testInstance = Test();
  testInstance.main();
}
