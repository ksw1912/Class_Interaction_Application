import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:http/http.dart' as http;
import 'package:spaghetti/ApiUrl.dart';
import 'dart:convert';

class Websocket {
  late StompClient stompClient;
  late String classId;
  final storage = FlutterSecureStorage();
  String jwt = '';

  Websocket(this.classId) {
    stompClient = StompClient(
      config: StompConfig(
        url: 'ws://${Apiurl().websocketUrl}/classroomEnter',
        onConnect: onConnect,
        beforeConnect: () async {
          jwt = (await storage.read(key: 'Authorization')) ?? '';
          print('waiting to connect...');
          //print(jwt);
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
    //도착
    stompClient.subscribe(
      destination: '${Apiurl().websocketUrl}/topic/classroom/$classId/',
      callback: (frame) {
        List<dynamic>? result = json.decode(frame.body!);
        print('Received message: $result');
      },
    );

    Timer.periodic(const Duration(seconds: 10), (_) {
      //메세지 보냄10초마다
      stompClient.send(
        destination: '/app/classroom/$classId/message',
        body: json.encode({'content': "text"}),
      );
    });
  }
}
