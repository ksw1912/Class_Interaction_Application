import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/Opinion.dart';

import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/quiz/Quiz.dart';

class classDetailPage extends StatefulWidget {
  final Classroom classroom;

  classDetailPage({super.key, required this.classroom});

  @override
  _ClassDetailPageState createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<classDetailPage> {
  TextEditingController contentController = TextEditingController();
  int? selectedRadio = 0;
  Websocket? websocket;
  String? jwt;
  final storage = FlutterSecureStorage();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeWebsocket();
    });
  }

  Future<void> _initializeWebsocket() async {
    String classId = widget.classroom.classId;
    User? user = Provider.of<UserProvider>(context, listen: false).user;
    UserCount userCount = Provider.of<UserCount>(context, listen: false);
    jwt = await storage.read(key: "Authorization") ?? "";
    websocket = Websocket(classId, user, jwt, context);
  }

  @override
  void dispose() {
    websocket?.unsubscribe();
    websocket?.stomClient(jwt, context).deactivate(); // websocket 연결 해제
    _scrollController.dispose();
    Provider.of<OpinionService>(context, listen: false).deleteAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ClassroomService, OpinionService, UserCount>(
        builder: (context, classService, opinionService, userCount, child) {
      List<Classroom> classList = classService.classroomList;
      List<Opinion> opinionList = opinionService.opinionList ?? [];

      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;

      Classroom? classData = widget.classroom;
      String className = classData.className;
      String classId = classData.classId;

      return Scaffold(
        resizeToAvoidBottomInset: false, // 키보드 오버플로우 방지
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await Dialogs.showEvaluationDialog(context, websocket!);
              await websocket?.unsubscribe();
              websocket?.stomClient(jwt, context).deactivate();
              Provider.of<OpinionService>(context, listen: false).deleteAll();
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back_rounded),
          ),
        ),
        body: PageView(
          children: [
            Container(
              child: Stack(
                children: [
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.01,
                    child: Text(className,
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w900,
                          fontFamily: 'NanumB',
                        )),
                  ),
                  Positioned(
                    left: screenWidth * 0.11,
                    top: screenHeight * 0.05,
                    child: Text('참여인원: ${userCount.userList[classId] ?? 0} 명',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'NanumB',
                        )),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.12,
                    child: Text('의견 제출하기',
                        style: TextStyle(
                          fontSize: screenWidth * 0.06,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'NanumB',
                        )),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.17,
                    child: Container(
                      height: 3,
                      width: screenWidth * 0.8,
                      color: Colors.black,
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.19,
                    child: Text('의견 선택 후 제출해 주세요',
                        style: TextStyle(
                            fontSize: screenWidth * 0.04, color: Colors.grey)),
                  ),
                  Positioned(
                    top: screenHeight * 0.22, // "이전 수업" 텍스트 아래 30px
                    left: screenWidth * 0.1,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.4,
                          child: opinionList.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.zero, // ListView의 패딩을 없앰
                                  itemCount: opinionList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() => selectedRadio = index);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey), // 테두리 선 추가
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16.0),
                                                child: Text(
                                                    opinionList[index].opinion),
                                              ),
                                              Radio<int>(
                                                value: index,
                                                groupValue: selectedRadio,
                                                onChanged: (int? value) {
                                                  setState(() =>
                                                      selectedRadio = value);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text('의견이 없습니다.'),
                                ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.65,
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
                        onPressed: opinionService.opinionSend
                            ? () {
                                websocket
                                    ?.opinionSend(opinionList[selectedRadio!]);
                                opinionService.setOpinionSend(false);
                              }
                            : null,
                        child: Text(
                          "제출하기",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: screenWidth * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.75,
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
                          addDialog(context);
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

Future<void> addDialog(BuildContext context) async {
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
    return Consumer2<ClassroomService, OpinionService>(
        builder: (context, classService, opinionService, child) {
      List<Opinion> opinionList = opinionService.opinionList;
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
                        child: Text('퀴즈를 풀어주세요.',
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
                            onPressed: () {
                              // sendQuiz(Quiz(quizId, classId, null));
                            },
                            child: Text(
                              "답안 제출",
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
