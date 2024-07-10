import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/class_Service.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'classCreatePage.dart';

class classRoomPage extends StatefulWidget {
  final int index;

  classRoomPage({super.key, required this.index});

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<classRoomPage> {
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
                    top: screenHeight * 0.87 - 60, // 수업 종료 버튼 위로 60px
                    child: Container(
                      width: screenWidth * 0.8, // 전체 너비 설정
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xffFDDA60),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  "의견 초기화",
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.039),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 30), // 버튼 사이의 간격
                          Expanded(
                            child: Container(
                              height: 45,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff28BD25),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  addDialog(context);
                                },
                                child: Text(
                                  "퀴즈 생성하기",
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.039),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.87,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClassCreatePage(
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "수업 종료하기",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // 공유 버튼 추가
                  Positioned(
                    right: screenWidth * 0.1,
                    top: screenHeight * 0.1,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/share_icon.png', // 이미지 경로
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                      ),
                      iconSize: screenWidth * 0.08,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Consumer<ClassService>(
                              builder: (context, classService, child) {
                                ClassData classData =
                                    classService.classList[widget.index];
                                String classNumber = classData.classnumber;

                                return Container(
                                  height: 300, // 모달 높이 크기
                                  margin: const EdgeInsets.only(
                                    left: 25,
                                    right: 25,
                                    bottom: 40,
                                  ), // 모달 좌우하단 여백 크기
                                  decoration: const BoxDecoration(
                                    color: Colors.white, // 모달 배경색
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20), // 모달 전체 라운딩 처리
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "수업 참여코드",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (int i = 0;
                                              i < classNumber.length;
                                              i++) ...[
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  classNumber[i],
                                                  style:
                                                      TextStyle(fontSize: 24),
                                                ),
                                              ),
                                            ),
                                            if (i < classNumber.length - 1)
                                              SizedBox(
                                                  width: i == 2
                                                      ? 20
                                                      : 5), // 3번째와 4번째 숫자 사이의 간격을 20px로 설정, 나머지는 5px로 설정
                                          ],
                                        ],
                                      ),
                                      SizedBox(height: 50),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context); // 기존 모달 닫기
                                          showQRCodeModal(context, classNumber);
                                        },
                                        child: Text("QR코드 생성"),
                                      ),
                                    ],
                                  ), // 모달 내부 디자인 영역
                                );
                              },
                            );
                          },
                          backgroundColor:
                              Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
                        );
                      },
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

void addDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    builder: (BuildContext context) {
      return AddClassDialog();
    },
  );
}

class AddClassDialog extends StatefulWidget {
  @override
  _AddClassDialogState createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassService>(builder: (context, classService, child) {
      List<ClassOpinionData> opinionList = classService.opinionList;
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController, // ScrollController 추가
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: screenHeight * 0.5,
            width: double.infinity,
            child: PageView(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Positioned(
                        left: screenWidth * 0.12,
                        top: screenHeight * 0.05,
                        child: Text('퀴즈를 생성해주세요.',
                            style: TextStyle(fontSize: screenWidth * 0.05)),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.1,
                        child: Container(
                          height: 3,
                          width: screenWidth * 0.8,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.4,
                        child: Container(
                          width: screenWidth * 0.8, // 화면 너비의 80%
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(192, 5, 165, 0),
                              surfaceTintColor: Color.fromARGB(192, 5, 165, 0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {},
                            child: Text(
                              "퀴즈 생성",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

// QR코드를 보여주는 모달 창
void showQRCodeModal(BuildContext context, String classNumber) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 40,
        ), // 기존 모달 창과 동일한 여백
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20), // 모달 전체 라운딩 처리
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 70.0, vertical: 10.0), // 가로 여백 추가
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20), // 위쪽 간격 추가
              QrImageView(
                data: classNumber,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: 20), // 간격 추가
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: classNumber));
                  Navigator.pop(context); // 모달창 닫기
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('수업코드가 클립보드에 복사되었습니다.')),
                  );
                },
                child: Text("수업코드 복사"),
              ),
              SizedBox(height: 20), // 아래쪽 간격 추가
            ],
          ),
        ),
      );
    },
    backgroundColor: Colors.transparent,
  );
}
