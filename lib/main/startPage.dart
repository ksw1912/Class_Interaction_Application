import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../login/LoginPage.dart';
import '../classroom/classEnterPage.dart';

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
                  child: Image.asset('assets/images/1.png'),
                ),
                
                Align(
                  alignment: Alignment(0, 0.6),
                  child: Text('자신의 의견을 반영하세요', style: TextStyle(fontSize: 20)),
                )
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
                )
              ],
            ),
          ),
          // 페이지 컨트롤러의 세 번째 위젯, 인덱스 : 2
          Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(0, -0.3),
                  child: Image.asset('assets/images/3.png'),
                ),
                Align(
                  alignment: Alignment(0, 0.3),
                  child: Text('교수님과 학생이 직접 소통할 수 있어요',
                      style: TextStyle(fontSize: 20)),
                ),
                Align(
                  alignment: Alignment(-0.5, 0.6),
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
                              const LoginPage(role: "instructor"),
                        ),
                      );
                    },
                    child: Text("교수님으로 시작 "),
                  ),
                ),
                Align(
                  alignment: Alignment(0.5, 0.6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(192, 56, 255, 1),
                      surfaceTintColor: Color.fromARGB(192, 56, 255, 1),
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
                    child: Text(" 학생으로 시작  "),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
