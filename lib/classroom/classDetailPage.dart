import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Dialog/CicularProgress.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/classroom/student/ClassEnterPage.dart'; // ClassEnterPage import
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'student/quiz_add_class_dialog.dart';

class classDetailPage extends StatefulWidget {
  final Classroom classroom;

  const classDetailPage({super.key, required this.classroom});

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
  bool isLoading = true;
  Future<void>? _webSocketFuture;
  OpinionService? _opinionService;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _webSocketFuture = _initializeWebsocket();
      // _checkClassStart();
      Provider.of<OpinionService>(context, listen: false).setOpinionSend(true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _opinionService = Provider.of<OpinionService>(context, listen: false);
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
    _opinionService?.deleteAll();
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
        resizeToAvoidBottomInset: false, // 키보드 오버플 로우
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              await Dialogs.showEvaluationDialog(
                  context, websocket!, widget.classroom.className);
              await websocket?.unsubscribe();
              websocket?.stomClient(jwt, context).deactivate();
              Provider.of<OpinionService>(context, listen: false).deleteAll();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassEnterPage(),
                ),
              );
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
                    left: screenWidth * 0.6,
                    top: screenHeight < 700
                        ? screenHeight * -0.001
                        : screenHeight * 0.01, // 선 위쪽에 배치
                    child: Image.asset(
                      'assets/images/opinion.png', // 이미지 경로를 설정해 주세요.
                      width: screenWidth * 0.3, // 이미지의 너비를 설정해 주세요.
                      height: screenHeight * 0.2, // 이미지의 높이를 설정해 주세요.
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.19,
                    child: Text('의견 선택 후 제출해 주세요',
                        style: TextStyle(
                            fontSize: screenWidth * 0.035, color: Colors.grey)),
                  ),
                  Positioned(
                    top: screenHeight * 0.23, // "이전 수업" 텍스트 아래 30px
                    left: screenWidth * 0.1,
                    child: Scrollbar(
                      thumbVisibility: true,
                      controller: _scrollController,
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: SizedBox(
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
                    top: screenHeight * 0.73,
                    child: SizedBox(
                      width: screenWidth * 0.8, // 화면 너비의 80%
                      height: screenHeight * 0.06,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff789bd0),
                          surfaceTintColor: Color.fromARGB(255, 228, 228, 228),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: opinionService.opinionSend
                            ? () {
                                setState(() {
                                  isLoading = true;
                                });
                                websocket
                                    ?.opinionSend(opinionList[selectedRadio!]);
                                opinionService.setOpinionSend(false);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            : null,
                        child: Text(
                          "제출하기",
                          style: TextStyle(
                            color: Colors.white,
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

Future<void> addDialog(BuildContext context, Websocket? websocket) async {
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
      return AddClassDialog(websocket);
    },
  );
}
