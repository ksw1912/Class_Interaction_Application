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
      // List<ClassData> classList = classService.classList;
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
                          Classroom classData = classList[index];
                          String dateFormat = DateFormat('yyyy-MM-dd')
                              .format(classData.updatedAt); // 날짜 변환
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
                              onPressed: () async {
                                Classroom classData = classList[index];
                                String classId = classData.classId;
                                await classService.classroomOpinions(
                                    context, classId);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ClassRoomPage(
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
                                        SizedBox(
                                          height: 1,
                                        ), // content와 date 사이의 간격
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
                                            backgroundColor: Colors.grey,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text('취소'),
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
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text('로그아웃'),
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
