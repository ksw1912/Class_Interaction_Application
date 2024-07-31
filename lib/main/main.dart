import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // kReleaseMode 사용을 위해 추가
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/classroom/student/EnrollmentService.dart';
import 'package:spaghetti/main/startPage.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/quiz/QuizService.dart';

void main() {
  runApp(
    // MyApp()
      DevicePreview(
        enabled: !kReleaseMode, // 릴리즈 모드가 아닌 경우에만 활성화
        builder: (context) => MyApp(),
      ),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClassroomService()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OpinionService()),
        ChangeNotifierProvider(create: (context) => EnrollmentService()),
        ChangeNotifierProvider(create: (context) => UserCount()),
        ChangeNotifierProvider(create: (context) => QuizService()),
      ],
      child: MaterialApp(
        builder: DevicePreview.appBuilder, // DevicePreview.appBuilder 사용
        useInheritedMediaQuery: true, // MediaQuery 정보를 상속 받음
        locale: DevicePreview.locale(context), // DevicePreview 로케일 사용
        home: StartPage(),
        theme: ThemeData(
          fontFamily: 'NanumB',
          scaffoldBackgroundColor: Colors.white, // 전체 앱의 Scaffold 배경색을 흰색으로 설정
          dialogBackgroundColor: Colors.white, // 다이얼로그 배경색을 흰색으로 설정
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white, // AppBar 배경색을 흰색으로 설정
            iconTheme:
                IconThemeData(color: Colors.black), // AppBar 아이콘 색상을 검정으로 설정
            titleTextStyle: TextStyle(
              color: Colors.black, // AppBar 타이틀 텍스트 색상을 검정으로 설정
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'NanumB',
            ),
            elevation: 0, // AppBar 그림자 없애기
          ),
        ),
      ),
    );
  }
}
