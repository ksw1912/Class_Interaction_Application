import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/UserCount.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/EditClassDialog.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/login/AuthService.dart';
import 'package:spaghetti/member/User.dart';
import 'package:spaghetti/member/UserProvider.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/opinion/OpinionVote.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'Quiz_class_dialog.dart';
import 'classCreatePage.dart';

class ClassRoomPage extends StatefulWidget {
  final Classroom? classRoomData;

  ClassRoomPage({super.key, required this.classRoomData});

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  int? selectedRadio = 0;
  Websocket? websocket;
  String? jwt;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeWebsocket();
  }

  Future<void> _initializeWebsocket() async {
    String classId = widget.classRoomData!.classId;
    User? user = Provider.of<UserProvider>(context, listen: false).user;
    UserCount userCount = Provider.of<UserCount>(context, listen: false);
    jwt = await storage.read(key: "Authorization") ?? "";
    websocket = Websocket(classId, user, jwt, context);
    userCount.evaluationList = [0, 0, 0, 0];
  }

  @override
  void dispose() async {
    await websocket?.unsubscribe();
    websocket?.stomClient(jwt, context).deactivate(); // websocket 연결 해제
    Provider.of<OpinionService>(context, listen: false).deleteAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ClassroomService, OpinionService, UserCount>(
        builder: (context, classService, opinionService, userCount, child) {
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;

      String className = widget.classRoomData!.className;
      String classId = widget.classRoomData!.classId;

      // classNumber 생성
      String classNumber =
          (widget.classRoomData!.classId.hashCode.abs() % 100000000).toString();

      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Container(
            height: screenHeight,
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
                  child: Text('참여인원: ${userCount.userList[classId] ?? 0}명',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w100,
                        fontFamily: 'NanumB',
                      )),
                ),
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.87 - 70,
                  child: Container(
                    width: screenWidth * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xfff7c678),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                //투표 초기화
                                opinionService.updateCountList();
                                //학생들에게 버튼 초기화 메세지
                                websocket?.opinionInit();
                              },
                              child: Text(
                                "의견 초기화",
                                style: TextStyle(fontSize: screenWidth * 0.039),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 30),
                        Expanded(
                          child: Container(
                            height: 45,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff85a3d5),
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
                                style: TextStyle(fontSize: screenWidth * 0.039),
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
                    width: screenWidth * 0.8,
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
                      onPressed: () async {
                        await Dialogs.showInstructorDialogEval(context);
                        websocket?.unsubscribe();
                        websocket?.stomClient(jwt, context).deactivate();
                        opinionService.deleteAll();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClassCreatePage(),
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
                Positioned(
                  right: screenWidth * 0.1,
                  top: screenHeight * 0.1,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/share_icon.png',
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                    ),
                    iconSize: screenWidth * 0.08,
                    onPressed: () {
                      classService.classroomMakePin(
                          context, classId, classNumber);
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Consumer<ClassroomService>(
                            builder: (context, classService, child) {
                              return Container(
                                height: 300,
                                margin: const EdgeInsets.only(
                                  left: 25,
                                  right: 25,
                                  bottom: 40,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
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
                                            width: 30, // 숫자 박스 너비
                                            height: 40, // 숫자 박스 높이
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Center(
                                              child: Text(
                                                classNumber[i],
                                                style: TextStyle(
                                                  fontSize: 30, // 숫자 크기
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (i == 3)
                                            SizedBox(width: 20) // 4번과 5번 사이 간격
                                          else if (i < classNumber.length - 1)
                                            SizedBox(width: 5), // 다른 숫자 사이 간격
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
                                        Navigator.pop(context);
                                        showQRCodeModal(context, classNumber);
                                      },
                                      child: Text("QR코드 생성"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                ),
                Positioned(
                  right: screenWidth * 0.23, // 적절히 조정
                  top: screenHeight * 0.1,
                  child: IconButton(
                    icon: Image.asset(
                      'assets/images/edit.png', // 수정 아이콘 경로
                      width: screenWidth * 0.06,
                      height: screenWidth * 0.06,
                    ),
                    iconSize: screenWidth * 0.08,
                    onPressed: () {
                      showEditClassDialog(context, websocket!);
                    },
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.2,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.55, // 차트 높이 조정
                    child: BarChartExample(),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  void showEditClassDialog(BuildContext context, Websocket websocket) {
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
        return EditClassDialog(
          classRoomData: widget.classRoomData,
          websocket: websocket,
        );
      },
    );
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
      return QuizClassDialog();
    },
  );
}

void showQRCodeModal(BuildContext context, String classNumber) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.only(
          left: 25,
          right: 25,
          bottom: 40,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              QrImageView(
                data: classNumber,
                version: QrVersions.auto,
                size: 200.0,
              ),
              SizedBox(height: 20),
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
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('수업코드가 클립보드에 복사되었습니다.')),
                  );
                },
                child: Text("수업코드 복사"),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
    backgroundColor: Colors.transparent,
  );
}

final List<Color> contentColors = [
  // 차트 컬러 리스트
  Color(0xff7b9bcf),
  Color(0xfff5c369),
  Color(0xffa4d3fb),
  Color(0xfff7a3b5),
  Color(0xfffcb29c),
  Color(0xffcab3e7), // mainTextcolor
];

class BarChartExample extends StatefulWidget {
  @override
  _BarChartExampleState createState() => _BarChartExampleState();
}

class _BarChartExampleState extends State<BarChartExample> {
  late SortingOrder _sortingOrder;

  @override
  void initState() {
    super.initState();
    _sortingOrder = SortingOrder.ascending; // 초기 정렬 설정을 오름차순으로 변경
  }

  void _toggleSortingOrder() {
    setState(() {
      _sortingOrder = _sortingOrder == SortingOrder.ascending
          ? SortingOrder.descending
          : SortingOrder.ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
        title: Text('수업 의견'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: _toggleSortingOrder,
          ),
        ],
      ),
      body: Consumer2<ClassroomService, OpinionService>(
          builder: (context, classService, opinionService, child) {
        List<Opinion> opinionList = opinionService.opinionList; // 옵션 배열
        List<OpinionVote> opinionCount =
            opinionService.countList; // 옵션 선택 개수 배열

        List<OpinionData> sortedData =
            List.generate(opinionList.length, (index) {
          return OpinionData(
              opinionList[index].opinion,
              opinionCount[index].count.toDouble(),
              contentColors[index % contentColors.length]);
        });

        sortedData.sort((a, b) => a.count.compareTo(b.count));
        if (_sortingOrder == SortingOrder.descending) {
          sortedData = sortedData.reversed.toList();
        }

        return SfCartesianChart(
          primaryXAxis: CategoryAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: MajorGridLines(width: 0),
            axisLine: AxisLine(width: 0),
          ),
          plotAreaBorderWidth: 0,
          legend: Legend(isVisible: false),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<OpinionData, String>>[
            BarSeries<OpinionData, String>(
              spacing: 0.2,
              dataSource: sortedData,
              xValueMapper: (OpinionData data, _) => data.opinion,
              yValueMapper: (OpinionData data, _) => data.count,
              pointColorMapper: (OpinionData data, _) => data.color,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            ),
          ],
        );
      }),
    );
  }
}

class OpinionData {
  OpinionData(this.opinion, this.count, this.color);
  final String opinion;
  final double count;
  final Color color;
}
