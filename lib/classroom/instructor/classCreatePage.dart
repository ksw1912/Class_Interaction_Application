import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/classroom.dart'; // Classroom 클래스 임포트
import 'package:spaghetti/classroom/instructor/AddClassDialog.dart'; // AddClassDialog 임포트
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:intl/intl.dart'; // DateFormat 임포트
import 'package:spaghetti/login/AuthService.dart'; // AuthService 임포트
import 'package:spaghetti/main/startPage.dart'; // StartPage 임포트
import 'package:spaghetti/member/User.dart'; // User 임포트
import 'package:spaghetti/member/UserProvider.dart'; // UserProvider 임포트
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'classRoomPage.dart';
import '../../login/LoginPage.dart';

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
    return Consumer2<ClassroomService, OpinionService>(
        builder: (context, classService, opinionService, child) {
      List<Classroom> classList =
          classService.classroomLists; // Classroom 클래스 사용

      final mediaQuery = MediaQuery.of(context);
      final screenHeight = mediaQuery.size.height;
      final screenWidth = mediaQuery.size.width;
      var user = Provider.of<UserProvider>(context).user; // UserProvider 사용

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
                    child: Text('${user?.username}님',
                        style: TextStyle(
                            fontSize: screenWidth * 0.03,
                            color: Color(0xff424141))),
                  ),
                  Positioned(
                    left: screenWidth * 0.12,
                    top: screenHeight * 0.23,
                    child: Text('수업 목록',
                        style: TextStyle(fontSize: screenWidth * 0.05)),
                  ),
                  Positioned(
                    top: screenHeight * 0.23 + 30, // "이전 수업" 텍스트 아래 30px
                    left: screenWidth * 0.1,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.45, // 목록을 위한 높이 조정
                      child: ListView.builder(
                        controller: _scrollController, // ScrollController 추가
                        padding: EdgeInsets.zero, // ListView의 패딩을 없앰
                        itemCount: classList.length,
                        itemBuilder: (context, index) {
                          Classroom classData = classList[index];
                          String dateFormat = classData.updatedAt != null
                              ? DateFormat('yyyy-MM-dd')
                                  .format(classData.updatedAt!)
                              : 'N/A';

                          // 아이콘 목록
                          List<IconData> icons = [
                            Icons.book,
                            Icons.school,
                            Icons.menu_book,
                          ];
                          IconData icon =
                              icons[index % icons.length]; // 순서대로 아이콘 선택

                          return Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      icon,
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
                                            classData.className,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16.0, // 텍스트 크기 설정
                                              fontWeight:
                                                  FontWeight.bold, // 폰트 굵기 설정
                                              color: Colors.black, // 폰트 색상 설정
                                              fontFamily: 'NanumB', // 폰트 패밀리 설정
                                            ),
                                          ),
                                          Text(
                                            dateFormat,
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
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromARGB(
                                            130, 230, 230, 230), // 기본 배경색 설정
                                        surfaceTintColor: Color.fromARGB(255,
                                            203, 203, 203), // 기본 표면 틴트 색상 설정
                                        foregroundColor:
                                            Colors.black, // 텍스트 색상 설정
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 15.0,
                                        ), // 버튼의 위아래 및 좌우 간격 설정
                                        shadowColor:
                                            Colors.transparent, // 그림자 색상 제거
                                      ),
                                      onPressed: () async {
                                        Classroom classData = classList[index];
                                        String classId = classData.classId;
                                        Classroom? classRoomData =
                                            await classService
                                                .classroomOpinions(
                                                    context, classId);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ClassRoomPage(
                                              classRoomData: classRoomData,
                                            ),
                                          ),
                                        );
                                      },
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
                    bottom: screenHeight * 0.1 - 50, // 하단에서 50px 위로
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.06, // 화면 너비의 80%
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff789ad0),
                          surfaceTintColor: Color(0xff789ad0),
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
                  // logout 아이콘의 Positioned 위치
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
                                            backgroundColor: Color(0xff848c99),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text('취소',
                                              style: TextStyle(
                                                  fontFamily: "NanumEB", color: Colors.white)),
                                        ),
                                      ),
                                      SizedBox(width: 10), // 버튼 사이 간격
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // 로그아웃 기능을 여기에 추가
                                            //토큰, 수업정보,유저 정보삭제
                                            AuthService().logout();
                                            user = null;
                                            classList = [];
                                            Navigator.of(context)
                                                .pop(); // 모달 닫기
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => StartPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xfff9a3b6),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text('로그아웃',
                                              style: TextStyle(fontFamily: "NanumEB",
                                                  color: Colors.white)),
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
