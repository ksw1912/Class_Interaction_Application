import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';

import 'classCreatePage.dart';

class ClassRoomPage extends StatefulWidget {
  final int index;

  ClassRoomPage({super.key, required this.index});

  @override
  _ClassRoomPageState createState() => _ClassRoomPageState();
}

class _ClassRoomPageState extends State<ClassRoomPage> {
  int? selectedRadio = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassroomService>(builder: (context, classService, child) {
      List<Classroom> classList = classService.classroomList;
      List<ClassOpinionData> opinionList = classService.opinionList;

      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      print(opinionList[0].content);
      Classroom classData = classList[widget.index];
      String className = classData.className;
      // String numberOfStudents = classData.numberStudents;

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
                  child: Text('참여인원: (숫자)명',
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.w100,
                        fontFamily: 'NanumB',
                      )),
                ),
                Positioned(
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.87 - 60,
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
                                backgroundColor: Color(0xffFDDA60),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {},
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
                      onPressed: () {
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
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                    ),
                    iconSize: screenWidth * 0.08,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Consumer<ClassroomService>(
                            builder: (context, classService, child) {
                              Classroom classData =
                                  classService.classroomList[widget.index];
                              // classid UUID로 변경함 수정해야함
                              // String classNumber = classData.classnumber;
                              String classNumber = "123456";
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
                                                style: TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ),
                                          if (i < classNumber.length - 1)
                                            SizedBox(width: i == 2 ? 20 : 5),
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
                  left: screenWidth * 0.1,
                  top: screenHeight * 0.2,
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.7,
                    child: PieChartExample(),
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
    return Consumer<ClassroomService>(builder: (context, classService, child) {
      List<ClassOpinionData> opinionList = classService.opinionList;
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: _scrollController,
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
                          width: screenWidth * 0.2,
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
  Colors.blue,
  Colors.yellow,
  Colors.purple,
  Colors.green,
  Colors.white // mainTextcolor
];

// 차트
class PieChartExample extends StatefulWidget {
  @override
  PieChart2State createState() => PieChart2State();
}

class PieChart2State extends State<PieChartExample> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<ClassroomService>(builder: (context, classService, child) {
      List<ClassOpinionData> opinionList = classService.opinionList;

      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      List<PieChartSectionData> showingSections() {
        final screenWidth = MediaQuery.of(context).size.width;

        return List.generate(opinionList.length, (i) {
          ClassOpinionData classOpinionData = opinionList[i];
          //터치했을때 이벤트
          //  final isTouched = i == touchedIndex;
          // final fontSize = isTouched ? screenWidth * 0.07 : screenWidth * 0.04;
          //  final radius = isTouched ? screenWidth * 0.15 : screenWidth * 0.12;
          //  const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

          int maxIndex = classService.maxCount(opinionList);
          final isMaxValue = i == maxIndex;
          final fontSize = isMaxValue ? screenWidth * 0.07 : screenWidth * 0.04;
          final radius = isMaxValue ? screenWidth * 0.15 : screenWidth * 0.12;
          const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

          return PieChartSectionData(
            color: contentColors[i],
            value: opinionList[i].count.toDouble(),
            title: opinionList[i].content + '%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: contentColors[4],
              shadows: shadows,
            ),
          );
        });
      }

      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.3,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: screenWidth * 0.15,
                  sections: showingSections(),
                ),
              ),
            ),
            const SizedBox(
              height: 15, //차트랑 컬러 박스 위치
            ),
            Container(
              width: screenWidth * 0.8,
              height: screenHeight * 0.22, // 하단위치
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: opinionList.length,
                itemBuilder: (context, index) {
                  ClassOpinionData classOpinionData = opinionList[index];
                  opinionList.sort((b, a) => a.count.compareTo(b.count));
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Indicator(
                        color: contentColors[index],
                        text: opinionList[index].content,
                        isSquare: true,
                      ),
                      SizedBox(
                        height: 15, //간격
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: screenWidth * 0.04,
          height: screenWidth * 0.04,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
