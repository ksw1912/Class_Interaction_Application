import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'classRoomPage.dart';
import '../class_Service.dart';

class ClassCreatePage extends StatefulWidget {
  const ClassCreatePage({super.key});

  @override
  State<ClassCreatePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ClassCreatePage> {
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
      List<ClassData> classList = classService.classList;
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;

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
                    child: Image.asset(
                      'assets/images/profil1.png',
                      width: screenWidth * 0.2,
                      height: screenWidth * 0.2,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.31,
                    top: screenHeight * 0.12,
                    child: Text('반가워요!',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    left: screenWidth * 0.31,
                    top: screenHeight * 0.15,
                    child: Text('김서원 대학원생님',
                        style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Color(0xff424141))),
                  ),
                  Positioned(
                    left: screenWidth * 0.12,
                    top: screenHeight * 0.23,
                    child: Text('새로운 수업을 생성해 주세요!',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.23 + 30,
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
                        onPressed: () {
                          addDialog(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "수업 생성하기",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "+",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.12,
                    top: screenHeight * 0.375,
                    child: Text('이전 수업',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    top: screenHeight * 0.375 + 30, // "이전 수업" 텍스트 아래 30px
                    left: screenWidth * 0.1,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.95 -
                          (screenHeight * 0.375 + 30), // 화면 높이의 90% - top 위치

                      child: ListView.builder(
                        controller: _scrollController, // ScrollController 추가
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
                                    builder: (_) => classRoomPage(
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
      var className = "";
      List<String>? ops;
      ClassroomService classroomService = new ClassroomService();
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController, // ScrollController 추가
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: screenHeight * 0.7,
            width: double.infinity,
            child: PageView(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Positioned(
                        left: screenWidth * 0.12,
                        top: screenHeight * 0.05,
                        child: Text('수업을 생성해주세요.',
                            style: TextStyle(fontSize: screenWidth * 0.05)),
                      ),
                      Positioned(
                        left: screenWidth * 0.12,
                        top: screenHeight * 0.225,
                        child: Text('수업 의견을 생성해주세요.',
                            style: TextStyle(fontSize: screenWidth * 0.04)),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.2,
                        child: Container(
                          height: 3,
                          width: screenWidth * 0.8,
                          color: Colors.black,
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.11,
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.07,
                          child: TextField(
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 214, 214, 214),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              hintText: '수업명을 입력해주세요',
                            ),
                            onChanged: (value) {
                              className = value;
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.75,
                        top: screenHeight * 0.21,
                        child: IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            classService.createOpinion(content: '');
                          },
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.225 + 40,
                        left: screenWidth * 0.1,
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.32,
                          child: Scrollbar(
                            thumbVisibility: false,
                            controller:
                                _scrollController, // ScrollController 추가
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero, // ListView의 패딩을 없앰
                              itemCount: opinionList.length,
                              itemBuilder: (context, index) {
                                ClassOpinionData classOpinionData =
                                    opinionList[index];

                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: screenWidth * 0.8,
                                    height: screenHeight * 0.07,
                                    child: TextField(
                                      onChanged: (value) {
                                        classService.updateOpinion(
                                            index: index, content: value);
                                      },
                                      decoration: InputDecoration(
                                        fillColor:
                                            Color.fromARGB(255, 214, 214, 214),
                                        filled: true,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: '의견을 적어주세요',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.57 + 30,
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
                            onPressed: () async {
                              var classroom =
                                  await classroomService.classroomCreate(
                                      context,
                                      className,
                                      ops ?? []); //??:의견 추가안했을 때는 빈 배열
                              // 이전 수업에다가 배열 값 을 추가
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "수업 생성하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "+",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
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
