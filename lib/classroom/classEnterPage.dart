import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class_Service.dart';

class ClassEnterPage extends StatefulWidget {
  const ClassEnterPage({super.key});

  @override
  State<ClassEnterPage> createState() => _ClassEnterPageState();
}

class _ClassEnterPageState extends State<ClassEnterPage> {
  ScrollController? _scrollController;
  String _output = 'Empty Scan Code';

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
                        style: TextStyle(fontSize: screenWidth * 0.03)),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.23,
                    child: Text('수업을 입장해 주세요',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.28,
                    child: Container(
                      width: 350,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 237, 241, 0),
                          surfaceTintColor: Color.fromARGB(192, 5, 165, 0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                            "QR코드로 입장하기                                                      +"),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.355,
                    child: Container(
                      width: 350,
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(192, 5, 165, 0),
                          surfaceTintColor: Color.fromARGB(192, 5, 165, 0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                            "번호로 입장하기                                                          +"),
                      ),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.5,
                    child: Text('이전 수업',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    top: screenHeight * 0.55,
                    left: screenWidth * 0.1,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.3,
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: classList.length,
                          itemBuilder: (context, index) {
                            ClassData classData = classList[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(192, 230, 225, 225),
                                  surfaceTintColor:
                                      Color.fromARGB(192, 5, 165, 0),
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text(
                                  classData.content,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          },
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
