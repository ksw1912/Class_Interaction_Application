import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart'; // kReleaseMode 사용을 위해 추가
import 'package:spaghetti/Websocket.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/classroom/student/EnrollmentService.dart';
import 'package:spaghetti/main/startPage.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/OpinionService.dart';

void main() {
  // HttpOverrides.global = NoCheckCertificateHttpOverrides();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode, // 릴리즈 모드가 아닌 경우에만 활성화
      builder: (context) => MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClassroomService()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => OpinionService()),
        ChangeNotifierProvider(create: (context) => EnrollmentService()),
      ],
      child: MaterialApp(
        builder: DevicePreview.appBuilder, // DevicePreview.appBuilder 사용
        useInheritedMediaQuery: true, // MediaQuery 정보를 상속 받음
        locale: DevicePreview.locale(context), // DevicePreview 로케일 사용
        home: StartPage(),
        theme: ThemeData(fontFamily: 'NanumB'),
      ),
    );
  }
}
