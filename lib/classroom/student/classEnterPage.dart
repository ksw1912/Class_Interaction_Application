import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Dialog/CicularProgress.dart';
import 'package:spaghetti/classroom/classDetailPage.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/classroom/student/Enrollment.dart';
import 'package:spaghetti/classroom/student/EnrollmentService.dart';
import 'package:spaghetti/classroom/student/qr_scan_page.dart';
import 'package:spaghetti/member/UserProvider.dart';
import '../../login/LoginPage.dart';

class ClassEnterPage extends StatefulWidget {
  const ClassEnterPage({super.key});

  @override
  State<ClassEnterPage> createState() => _ClassEnterPageState();
}

class _ClassEnterPageState extends State<ClassEnterPage> {
  ScrollController? _scrollController;
  String output = 'Empty Scan Code';
  final TextEditingController _controller = TextEditingController();
  bool isEditing = false;
  bool isLoading = false;
  // late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<EnrollmentService, ClassroomService>(
        builder: (context, enrollmentService, classroomService, child) {
      List<Enrollment> enrollList = enrollmentService.enrollList;
      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      final user = Provider.of<UserProvider>(context).user;
      String classNumber = "";
      return Scaffold(
        resizeToAvoidBottomInset: false, // 키보드 오버플로우 방지
        body: PageView(
          children: [
            Container(
              child: Stack(
                children: [
                  if (isLoading) CircularProgress.build(),
                  Positioned(
                    left: screenWidth * 0.13,
                    top: screenHeight * 0.11,
                    child: Image.asset(
                      'assets/images/profil1.png',
                      width: screenWidth * 0.15,
                      height: screenWidth * 0.15,
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
                    child: Text('${user?.username}님',
                        style: TextStyle(fontSize: screenWidth * 0.03)),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.23,
                    child: Text('수강 목록',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    top: screenHeight * 0.28,
                    left: screenWidth * 0.1,
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.45, // 목록을 위한 높이 조정
                      child: ListView.builder(
                        controller: _scrollController, // ScrollController 추가
                        padding: EdgeInsets.zero, // ListView의 패딩을 없앰
                        itemCount: enrollList.length,
                        itemBuilder: (context, index) {
                          Enrollment enrollmentData = enrollList[index];
                          String dateFormat = DateFormat('yyyy-MM-dd')
                              .format(enrollmentData.updatedAt);

                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.book,
                                      size: screenWidth * 0.1,
                                      color: Colors.blue,
                                    ), // 작은 아이콘 추가
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            enrollmentData.classroom.className,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.0, // 텍스트 크기 설정
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontFamily: 'NanumB',
                                            ),
                                          ),
                                          Text(
                                            dateFormat,
                                            style: TextStyle(
                                              fontSize: 12.0, // 텍스트 크기 설정
                                              fontWeight: FontWeight.normal,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isEditing
                                        ? IconButton(
                                            icon: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.red),
                                            onPressed: () {
                                              // 삭제 기능 추가

                                              setState(() {
                                                isLoading = true;
                                              });
                                              enrollmentService
                                                  .enrollmentDelete(
                                                      context,
                                                      enrollList[index]
                                                          .enrollmentID);
                                              enrollmentService
                                                  .removeEnrollment(
                                                      enrollmentData
                                                          .classroom.classId);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                          )
                                        : ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color.fromARGB(
                                                  130,
                                                  230,
                                                  230,
                                                  230), // 기본 배경색 설정
                                              surfaceTintColor: Color.fromARGB(
                                                  255,
                                                  203,
                                                  203,
                                                  203), // 기본 표면 틴트 색상 설정
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 15.0,
                                              ), // 버튼의 위아래 및 좌우 간격 설정
                                              shadowColor: Colors.transparent,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              try {
                                                var classroom =
                                                    await classroomService
                                                        .classroomOpinions(
                                                            context,
                                                            enrollmentData
                                                                .classroom
                                                                .classId);
                                                if (classroom != null) {
                                                  enrollmentService
                                                      .addEnrollList(
                                                          context, classroom);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          classDetailPage(
                                                        classroom: classroom,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } finally {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            },
                                            child: Text(
                                              "수업 입장하기",
                                              style: TextStyle(
                                                fontSize: 14.0, // 텍스트 크기 설정
                                                fontWeight: FontWeight.normal,
                                                color: Color(0xff4E4E4E),
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: 1,
                                color: Colors.grey[300],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    bottom: screenHeight * 0.1 + 60,
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xfffbaf01),
                          surfaceTintColor: Color(0xfffbaf01),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QRScanPage()),
                          );
                          if (result != null) {
                            setState(() {
                              output = result;
                            });

                            setState(() {
                              isLoading = true;
                            });
                            classroomService.classroomOpinions(context, output);
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: Text("QR코드로 입장하기",
                            style: TextStyle(fontSize: screenWidth * 0.04)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    bottom: screenHeight * 0.1,
                    child: SizedBox(
                      width: screenWidth * 0.8,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff789bd0),
                          surfaceTintColor: Color(0xff789bd0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                            ),
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom,
                                    ),
                                    child: Container(
                                      margin: const EdgeInsets.only(top: 40),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                              height: 30), // 모달 상단에서 30px 아래
                                          Text(
                                            "수업 참여코드",
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                for (int i = 0; i < 8; i++) ...[
                                                  Container(
                                                    width: 30, // 숫자 박스 너비
                                                    height: 40, // 숫자 박스 높이
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors.black),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        _controller.text
                                                                    .length >
                                                                i
                                                            ? _controller
                                                                .text[i]
                                                            : '',
                                                        style: TextStyle(
                                                            fontSize: 24),
                                                      ),
                                                    ),
                                                  ),
                                                  if (i == 3)
                                                    SizedBox(
                                                        width:
                                                            20) // 4번과 5번 사이 간격
                                                  else if (i < 7)
                                                    SizedBox(
                                                        width:
                                                            5), // 다른 숫자 사이 간격
                                                ],
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          TextField(
                                            controller: _controller,
                                            maxLength: 8,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              counterText: '',
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                                color: Colors.transparent),
                                            cursorColor: Colors.transparent,
                                            onChanged: (value) {
                                              setState(() {
                                                classNumber = value;
                                              });
                                            },
                                            autofocus: true, // 자동으로 키보드 띄우기
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xff789bd0),
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              var classroom =
                                                  await classroomService
                                                      .studentEnterClassPin(
                                                          context, classNumber);
                                              setState(() {
                                                _controller.clear();
                                                isLoading = false;
                                              });
                                              if (classroom == null) {
                                                Navigator.pop(context);
                                              } // 기존 모달 닫기
                                              else {
                                                enrollmentService.addEnrollList(
                                                    context, classroom);
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        classDetailPage(
                                                      classroom: classroom,
                                                    ),
                                                  ),
                                                );
                                              }
                                              // 입력된 코드로 수업 입장 기능 추가
                                            },
                                            child: Text("수업 입장하기"),
                                          ),
                                          SizedBox(
                                              height: 30), // 모달 하단에서 30px 위
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            backgroundColor: Colors.transparent,
                          );
                        },
                        child: Text(
                          "번호로 입장하기",
                          style: TextStyle(fontSize: screenWidth * 0.04),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.1,
                    top: screenHeight * 0.215,
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          isEditing = !isEditing;
                        });
                      },
                      child: Text(
                        isEditing ? '확인' : '편집',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04,
                          color: Color(0xff789bd0),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: screenWidth * 0.1,
                    top: screenHeight * 0.12,
                    child: IconButton(
                      icon: Image.asset(
                        'assets/images/logout.png', // 이미지 경로 확인
                        width: screenWidth * 0.08,
                        height: screenWidth * 0.08,
                      ),
                      iconSize: screenWidth * 0.08,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              contentPadding: EdgeInsets.all(20),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '로그아웃 하시겠습니까?',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // 모달 닫기
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xfff7f8fc),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                              color: Color(0xff789bd0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10), // 버튼 사이 간격
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // 로그아웃 기능을 여기에 추가
                                            Navigator.of(context)
                                                .pop(); // 모달 닫기
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    LoginPage(role: "student"),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xff789bd0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            '로그아웃',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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
