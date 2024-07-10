import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../login/LoginPage.dart';
import '../classroom/student/classEnterPage.dart';

class PageSlideExample extends StatefulWidget {
  const PageSlideExample({super.key});

  @override
  PageSlideExampleState createState() => PageSlideExampleState();
}

class PageSlideExampleState extends State<PageSlideExample> {
  // 페이지뷰 컨트롤러 설정
  // initialPage : 0부터 차례대로 위젯들의 인덱스를 의미
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController, // 페이지 컨트롤러 설정
        children: [
          // 페이지 컨트롤러의 첫 번째 위젯, 인덱스 : 0
          Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0.3, -0.1),
                  child: Image.asset(
                    'assets/images/1.png',
                    height: 400,
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child: Text('자신의 의견을 반영하세요', style: TextStyle(fontSize: 20)),
                ),
                Align(
                  alignment: Alignment(0, 0.8),
                  child: Image.asset('assets/images/Onboarding1.png',
                      width: 80, fit: BoxFit.fill),
                ),
              ],
            ),
          ),
          // 페이지 컨트롤러의 두 번째 위젯, 인덱스 : 1
          Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, 0),
                  child: Image.asset('assets/images/2.png'),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child:
                      Text('부끄러울 땐 온라인으로 말해요', style: TextStyle(fontSize: 20)),
                ),
                Align(
                  alignment: Alignment(0, 0.8),
                  child: Image.asset('assets/images/Onboarding2.png',
                      width: 80, fit: BoxFit.fill),
                ),
              ],
            ),
          ),
          // 페이지 컨트롤러의 세 번째 위젯, 인덱스 : 2
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      'assets/images/3.png', // 이미지 경로 설정
                      height: 200,
                      width: MediaQuery.of(context).size.width, // 화면 너비에 맞게 설정
                      fit: BoxFit.cover,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '교수님과 학생이 직접 소통할 수 있어요',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(role: "instructor"),
                              ),
                            );
                          },
                          child: Text('교수님으로 시작'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 5, 179, 214),
                            surfaceTintColor: Color.fromARGB(255, 5, 179, 214),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ), // 배경색 설정
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(role: "student"),
                              ),
                            );
                          },
                          child: Text('학생으로 시작'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(192, 56, 255, 1),
                            surfaceTintColor: Color.fromARGB(192, 56, 255, 1),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Image.asset('assets/images/Onboarding3.png',
                        width: 100, fit: BoxFit.fill),
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
