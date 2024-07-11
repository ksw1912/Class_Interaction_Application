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
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController, // 페이지 컨트롤러 설정
        children: [
          // 페이지 컨트롤러의 첫 번째 위젯, 인덱스 : 0
          Container(
            child: Stack(
              children: [
                Positioned(
                  left: screenWidth * 0.09,
                  top: screenHeight * 0.01,
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.9,
                    child: Image.asset('assets/images/1.png'),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.25,
                  top: screenHeight * 0.7,
                  child: Text('자신의 의견을 반영하세요',
                      style: TextStyle(fontSize: screenWidth * 0.05)),
                ),
                Positioned(
                  left: screenWidth * 0.4,
                  top: screenHeight * 0.775,
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
                Positioned(
                  left: screenWidth * 0.05,
                  top: screenHeight * 0.01,
                  child: Container(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.9,
                    child: Image.asset('assets/images/2.png'),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.2,
                  top: screenHeight * 0.7,
                  child: Text('부끄러울 땐 온라인으로 말해요',
                      style: TextStyle(fontSize: screenWidth * 0.05)),
                ),
                Positioned(
                  left: screenWidth * 0.4,
                  top: screenHeight * 0.775,
                  child: Image.asset('assets/images/Onboarding2.png',
                      width: 80, fit: BoxFit.fill),
                ),
              ],
            ),
          ),

          Container(
            child: Stack(
              children: [
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.01,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.95,
                    child: Image.asset('assets/images/3.png'),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.7,
                  child: Text('교수님과 학생이 직접 소통할 수 있어요',
                      style: TextStyle(fontSize: screenWidth * 0.05)),
                ),
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.85,
                  child: Container(
                    width: screenWidth * 0.375,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(192, 5, 165, 0),
                        surfaceTintColor: Color.fromARGB(192, 5, 165, 0),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage(role: "instructor"),
                          ),
                        );
                      },
                      child: Text(
                        "교수님으로 시작",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                ),
                // 페이지 컨트롤러의 세 번째 위젯, 인덱스 : 2
                Positioned(
                  left: screenWidth * 0.525,
                  top: screenHeight * 0.85,
                  child: Container(
                    width: screenWidth * 0.375, // 화면 너비의 80%
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 5, 179, 214),
                        surfaceTintColor: Color.fromARGB(255, 5, 179, 214),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginPage(role: "student"),
                          ),
                        );
                      },
                      child: Text(
                        "학생으로 시작",
                        style: TextStyle(
                            color: Colors.white, fontSize: screenWidth * 0.035),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.4,
                  top: screenHeight * 0.775,
                  child: Image.asset('assets/images/Onboarding3.png',
                      width: 80, fit: BoxFit.fill),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
