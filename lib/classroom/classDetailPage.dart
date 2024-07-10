import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/class_Service.dart';

class classDetailPage extends StatelessWidget {
  classDetailPage({super.key, required this.index});

  final int index;

  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassService>(builder: (context, classService, child) {
      List<ClassData> classList = classService.classList;

      List<ClassOpinionData> opinionList = classService.opinionList;
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;

      ClassData classData = classList[index];
      ClassOpinionData classOpinionData = opinionList[index];
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
                        itemCount: classList.length,
                        itemBuilder: (context, index) {
                          ClassData classData = classList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(
                                    130, 230, 230, 230), // 기본 배경색 설정
                                surfaceTintColor: Color.fromARGB(
                                    255, 203, 203, 203), // 기본 표면 틴트 색상 설정
                                foregroundColor: Colors.black, // 텍스트 색상 설정
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 15.0,
                                ), // 버튼의 위아래 및 좌우 간격 설정
                                shadowColor: Colors.transparent, // 그림자 색상 제거
                                // overlayColor 속성 제거
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => classDetailPage(
                                      index: index,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          classData.content,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 16.0, // 텍스트 크기 설정
                                            fontWeight:
                                                FontWeight.bold, // 폰트 굵기 설정
                                            color: Colors.black, // 폰트 색상 설정
                                            fontFamily: 'NanumB', // 폰트 패밀리 설정
                                          ),
                                        ),
                                        SizedBox(
                                          height: 1,
                                        ), // content와 date 사이의 간격
                                        Text(
                                          classData.date,
                                          style: TextStyle(
                                            fontSize: 12.0, // 텍스트 크기 설정
                                            fontWeight:
                                                FontWeight.normal, // 폰트 굵기 설정
                                            color: Colors.grey, // 폰트 색상 설정
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment:
                                        Alignment.center, // 텍스트를 수직 중앙에 정렬
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0), // 왼쪽에 약간의 간격 추가
                                      child: Text(
                                        "수업 입장하기",
                                        style: TextStyle(
                                          fontSize: 14.0, // 텍스트 크기 설정
                                          fontWeight:
                                              FontWeight.normal, // 폰트 굵기 설정
                                          color: Color(0xff4E4E4E), // 폰트 색상 설정
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                          //addDialog(context);
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
