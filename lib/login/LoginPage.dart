import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/classroom/student/Enrollment.dart';
import 'package:spaghetti/classroom/student/EnrollmentService.dart';
import 'package:spaghetti/classroom/student/classEnterPage.dart';
import 'package:spaghetti/classroom/instructor/classCreatePage.dart';
import 'package:spaghetti/login/AuthService.dart';
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/member/UserProvider.dart';
import '../main/startPage.dart';
import '../login/joinMember.dart';

class LoginPage extends StatefulWidget {
  final String role;

  const LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    String name;

    if (widget.role == "student") {
      name = "학생님";
    } else {
      name = "교수님";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StartPage(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 50,
            left: 30,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('수업은 언제나',
                    style: TextStyle(fontSize: 20, color: Color(0xff696868))),
                Text('에코(Echo) 클래스룸', style: TextStyle(fontSize: 25)),
                Text('$name, 반가워요!',
                    style: TextStyle(fontSize: 17, color: Color(0xff696868))),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 130.0), // 이 값을 조정하여 높이를 내릴 수 있습니다.
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: '아이디',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'NanumB',
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscure
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                      ),
                      style: TextStyle(
                        fontFamily: 'NanumB',
                      ),
                    ),
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffbaf01),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async {
                          var email = emailController.text;
                          var password = passwordController.text;

                          // 로그인 요청
                          var response = await AuthService()
                              .login(email, password, widget.role);
                          if (response.statusCode == 200) {
                            User user = AuthService()
                                .parseUser(json.decode(response.body));
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(user);
                            if (widget.role == "student") {
                              List<Enrollment> enrollments = AuthService()
                                      .parseEnrollments(
                                          json.decode(response.body)) ??
                                  [];
                              Provider.of<EnrollmentService>(context,
                                      listen: false)
                                  .setEnrollList(enrollments);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ClassEnterPage()),
                              );
                            } else {
                              List<Classroom> classrooms = AuthService()
                                      .parseClassrooms(
                                          json.decode(response.body)) ??
                                  [];
                              Provider.of<ClassroomService>(context,
                                      listen: false)
                                  .setClassrooms(classrooms);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ClassCreatePage()),
                              );
                            }
                          } else {
                            setState(() {
                              errorMessage = "이메일 또는 비밀번호를 확인하세요";
                            });
                          }
                        },
                        child: Text(
                          '로그인',
                          style: TextStyle(
                            fontFamily: 'NanumB',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Joinmember(),
                          ),
                        );
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: RichText(
                          text: TextSpan(
                            text: "계정이 없으신가요? ",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                            children: <TextSpan>[
                              TextSpan(
                                text: "가입하기",
                                style:
                                    TextStyle(fontSize: 13, color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
