import 'package:flutter/material.dart';
import 'package:spaghetti/classCreatePage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        children: [
          Container(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment(-0.78, -0.68),
                  child: Text('수업은 언제나', style: TextStyle(fontSize: 13)),
                ),
                Align(
                  alignment: Alignment(-0.7, -0.6),
                  child: Text('에코(Echo) 클래스룸', style: TextStyle(fontSize: 20)),
                ),
                Align(
                  alignment: Alignment(-0.78, -0.51),
                  child: Text('교수님, 반가워요!', style: TextStyle(fontSize: 10)),
                ),
                Align(
                  alignment: Alignment(0, 0.4),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                      surfaceTintColor: Colors.yellow,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {},
                    child:
                        Text("                   카카오로 시작하기                   "),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.4, 0.39),
                  child: Image.asset(
                    'assets/images/icon_Kakao.png',
                    width: 27,
                    height: 27,
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(192, 175, 173, 172),
                      surfaceTintColor: Color.fromARGB(192, 175, 173, 172),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClassCreatePage()),
                      );
                    },
                    child: Text(
                        "                     구글로 시작하기                     "),
                  ),
                ),
                Align(
                  alignment: Alignment(-0.4, 0.6),
                  child: Image.asset(
                    'assets/images/icon_Google.png',
                    width: 50,
                    height: 50,
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
