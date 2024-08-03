import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/student/Enrollment.dart';
import 'package:spaghetti/main/startPage.dart';
import 'package:spaghetti/member/Instructor.dart';
import 'package:spaghetti/member/Student.dart';
import 'package:spaghetti/member/User.dart';

class AuthService {
  //url 주소
  final String apiUrl = Apiurl().url;
  final storage = FlutterSecureStorage();
  BuildContext context;
  AuthService(this.context);

  Future<http.Response> login(
      String email, String password, String role) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'email': email,
            'password': password,
            'role': role,
          },
        ),
      );

      if (response.statusCode == 200) {
        // response.body를 JSON으로 파싱하여 토큰 추출
        var token = response.headers['authorization'];
        // FlutterSecureStorage에 토큰 저장

        startTokenDeletionTimer(context);

        await storage.write(key: 'Authorization', value: token);
      } else {}

      return response;
    } catch (e) {
      return http.Response('Error 발생', 500);
    }
  }

  void startTokenDeletionTimer(BuildContext context) {
    // 2시간 후 토큰 삭제 타이머
    Timer(Duration(hours: 2), () async {
      await logout();
      showLogoutDialog(context);
    });
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('알림'),
          content: Text('로그인 시간이 만료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: Text('확인'),
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => StartPage()),
                    (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout() async {
    // FlutterSecureStorage에서 토큰 삭제
    await storage.delete(key: 'Authorization');
  }

  Future<String?> getToken() async {
    // FlutterSecureStorage에서 토큰 불러오기
    return await storage.read(key: 'Authorization');
  }

  User parseUser(Map<String, dynamic> json) {
    var info = json['user'] ?? json;
    if (info['role'] == 'student') {
      return Student.fromJson(info);
    } else if (info['role'] == 'instructor') {
      return Instructor.fromJson(info);
    } else {
      return User.fromJson(info);
    }
  }

  List<Classroom>? parseClassrooms(Map<String, dynamic> json) {
    var classroomsJson = json['classrooms'] as List?;
    if (classroomsJson == null) {
      return null;
    }
    List<Classroom> classrooms =
        classroomsJson.map((json) => Classroom.fromJson(json)).toList();
    return classrooms;
  }

  List<Enrollment>? parseEnrollments(Map<String, dynamic> json) {
    var enrollmentJson = json['enrollments'] as List?;
    if (enrollmentJson == null) {
      return null;
    }
    List<Enrollment> enrollments =
        enrollmentJson.map((json) => Enrollment.fromJson(json)).toList();
    return enrollments;
  }

//회원가입
  Future<http.Response> join(
    String username,
    String email,
    String password,
    String role,
    String department,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/join'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'username': username,
            'email': email,
            'password': password,
            'role': role,
            'department': department,
          },
        ),
      );

      if (response.statusCode == 200) {
        // response.body를 JSON으로 파싱하여 토큰 추출
        var token = response.headers['Authorization'];
        // FlutterSecureStorage에 토큰 저장

        await storage.write(key: 'Authorization', value: token);
      } else {}

      return response;
    } catch (e) {
      return http.Response('Error 발생', 500);
    }
  }

  // 아이디체크
  Future<http.Response> checkEmail(
    String email,
  ) async {
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/checkEmail'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'email': email,
          },
        ),
      );

      if (response.statusCode == 200) {
        // response.body를 JSON으로 파싱하여 토큰 추출
        var token = response.headers['Authorization'];
        // FlutterSecureStorage에 토큰 저장

        await storage.write(key: 'Authorization', value: token);
      } else {}

      return response;
    } catch (e) {
      return http.Response('Error 발생', 500);
    }
  }
}
