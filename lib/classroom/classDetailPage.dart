import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/class_Service.dart';

class classDetailPage extends StatefulWidget {
  final int index;

  classDetailPage({super.key, required this.index});

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<classDetailPage> {
  TextEditingController contentController = TextEditingController();
  int? selectedRadio = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassService>(builder: (context, classService, child) {
      List<ClassData> classList = classService.classList;
      List<ClassOpinionData> opinionList = classService.opinionList;

      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      print(opinionList[0].content);
      ClassData classData = classList[widget.index];
      String className = classData.content;
      String numberOfStudents = classData.numberStudents;

      return Scaffold(
        resizeToAvoidBottomInset: false, // 키보드 오버플로우 방지
        body: PageView(
          children: [
            Container(
              child: Stack(
                children: [
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.1,
                    child: Text(className,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'NanumB',
                        )),
                  ),
                  Positioned(
                    left: screenWidth * 0.11,
                    top: screenHeight * 0.15,
                    child: Text('참여인원: ' + numberOfStudents + '명',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'NanumB',
                        )),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.25,
                    child: Text('의견 제출하기',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'NanumB',
                        )),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.3,
                    child: Container(
                      height: 3,
                      width: screenWidth * 0.8,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.32,
                    child: Text('의견 선택 후 제출해 주세요',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04, color: Colors.grey)),
                  ),
                  Positioned(
                    top: screenHeight * 0.375, // "이전 수업" 텍스트 아래 30px
                    left: screenWidth * 0.1,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.95 -
                          (screenHeight * 0.375 + 30), // 화면 높이의 90% - top 위치

                      child: ListView.builder(
                        padding: EdgeInsets.zero, // ListView의 패딩을 없앰
                        itemCount: opinionList.length,
                        itemBuilder: (context, index) {
                          ClassOpinionData classOpinionData =
                              opinionList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: RadioListTile(
                              title: Text(classOpinionData.content),
                              value: index,
                              groupValue: selectedRadio,
                              onChanged: (int? value) {
                                setState(() => selectedRadio = value);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.85,
                    child: Container(
                      width: screenWidth * 0.8, // 화면 너비의 80%
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 228, 228, 228),
                          surfaceTintColor: Color.fromARGB(255, 228, 228, 228),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // addDialog(context);
                        },
                        child: Text(
                          "퀴즈풀기",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
