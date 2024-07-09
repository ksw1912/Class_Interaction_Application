import 'package:flutter/material.dart';
import 'package:spaghetti/classroom/classCreatePage.dart';

class LoginPage extends StatelessWidget {
  final String role;

  const LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String name;

    if (role == "student") {
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
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
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
                  child: Text('$name, 반가워요!', style: TextStyle(fontSize: 10)),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClassCreatePage()),
                      );
                    },
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
