/*
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'ApiUrl.dart';

class Websocket {
  final IO.Socket socket = IO.io(
      'ex)$Apiurl', IO.OptionBuilder().setTransports(['websocket']).build());

  List<String> messages = []; // 메시지 목록을 저장할 리스트

  @override
  //Widget build(BuildContext context) {
  //  return Scaffold(
  //    body: Center(
  //      child: Text('Chat will go here'),
  //    ),
  );
 }

  void sokectEventSetting() {
    socket.onConnect((_) {
      print('Connected to server');
    });
    socket.onDisconnect((_) {
      print('Disconnected from server');
    });
    socket.onError((error) {
      print('Error: $error');
      // 에러를 감지하고 그에 따라 핸들링을 추가합니다.
    });

    socket.connect();
    socket.on('message', (data) {
      print('Received message: $data');
      // 메세지를 감지하고 UI에 표시하거나 처리합니다.
      setState(() {
        messages.add(data);
      });
    });
  }

  void sendMessage(String message) {
    socket.emit('chatMessage', message);
    // 메시지를 서버로 보내는 코드입니다.
  }
}
*/
