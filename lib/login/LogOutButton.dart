import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 로그아웃 버튼의 Positioned 위치
          Positioned(
            right: MediaQuery.of(context).size.width * 0.1,
            top: MediaQuery.of(context).size.height * 0.1,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      // Center 위젯을 사용하여 화면 가운데에 배치
                      child: Container(
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
                        child: Center(
                          // Container 내의 내용도 가운데 정렬
                          child: Text('로그아웃 확인'),
                        ),
                      ),
                    );
                  },
                  backgroundColor:
                      Colors.transparent, // 앱 <=> 모달의 여백 부분을 투명하게 처리
                );
              },
              child: IconButton(
                icon: Image.asset(
                  'assets/images/logout.png', // 이미지 경로 확인
                  width: MediaQuery.of(context).size.width * 0.08,
                  height: MediaQuery.of(context).size.width * 0.08,
                ),
                iconSize: MediaQuery.of(context).size.width * 0.08,
                onPressed: () {
                  // 로그아웃 기능을 여기에 추가
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
