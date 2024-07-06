import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class_Service.dart';

class ClassCreatePage extends StatefulWidget {
  const ClassCreatePage({super.key});

  @override
  State<ClassCreatePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ClassCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClassService>(builder: (context, classService, child) {
      // memoService로 부터 memoList 가져오기
      List<ClassData> classList = classService.classList;

      return Scaffold(
        body: PageView(
          children: [
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.8, -0.6),
                    child: Image.asset(
                      'assets/images/profil1.png',
                      width: 75,
                      height: 75,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.35, -0.55),
                    child: Text('반가워요!', style: TextStyle(fontSize: 15)),
                  ),
                  Align(
                    alignment: Alignment(-0.3, -0.50),
                    child: Text('김서원 대학원생님', style: TextStyle(fontSize: 10)),
                  ),
                  Align(
                    alignment: Alignment(-0.6, -0.3),
                    child: Text('새로운 수업을 생성해 주세요!',
                        style: TextStyle(fontSize: 15)),
                  ),
                  Align(
                    alignment: Alignment(-0.1, -0.17),
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
                              builder: (context) => const ClassCreatePage()),
                        );
                      },
                      child: Text(
                          "수업 생성하기                                                       +"),
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.7, 0),
                    child: Text('이전 수업', style: TextStyle(fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 325.0, left: 50), // ListView 위치 조정
                    child: ListView.builder(
                      itemCount: classList.length,
                      itemBuilder: (content, index) {
                        ClassData classData = classList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: .0),
                          child: Container(
                            alignment: Alignment.centerLeft, // 아이템 정렬
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(192, 230, 225, 225),
                                surfaceTintColor:
                                    Color.fromARGB(192, 5, 165, 0),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ClassCreatePage()),
                                );
                              },
                              child: Text(
                                classData.content,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
