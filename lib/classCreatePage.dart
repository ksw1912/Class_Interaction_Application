import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'classDetailPage.dart';
import 'class_Service.dart';

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
                        style: TextStyle(fontSize: screenWidth * 0.03)),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.23,
                    child: Text('새로운 수업을 생성해 주세요!',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.28,
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
                      child: Text(
                          "수업 생성하기                                                       +"),
                    ),
                  ),
                  Positioned(
                    left: screenWidth * 0.1,
                    top: screenHeight * 0.375,
                    child: Text('이전 수업',
                        style: TextStyle(fontSize: screenWidth * 0.04)),
                  ),
                  Positioned(
                    top: screenHeight * 0.45,
                    left: screenWidth * 0.1,
                    child: Container(
                      width: screenWidth * 0.8,
                      height: screenHeight * 0.4,
                      child: ListView.builder(
                        controller: _scrollController, // ScrollController 추가
                        itemCount: classList.length,
                        itemBuilder: (context, index) {
                          ClassData classData = classList[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => classDetailPage(
                                      index: index,
                                    ),
                                  ),
                                );
                              },
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
    return Consumer<ClassOpinion>(builder: (context, classOpinion, child) {
      List<ClassOpinionData> opinionList = classOpinion.opinionList;
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
            height: screenHeight * 0.7,
            width: double.infinity,
            child: PageView(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.05,
                        child: Text('수업을 생성해주세요.',
                            style: TextStyle(fontSize: screenWidth * 0.05)),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
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
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.75,
                        top: screenHeight * 0.21,
                        child: IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            classOpinion.createOpinion(content: '');
                          },
                        ),
                      ),
                      Positioned(
                        top: screenHeight * 0.3,
                        left: screenWidth * 0.1,
                        child: Container(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.2,
                          child: Scrollbar(
                            thumbVisibility: false,
                            controller:
                                _scrollController, // ScrollController 추가
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
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
                        left: screenWidth * 0.12,
                        top: screenHeight * 0.54,
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
                          child: Text(
                              "수업 생성하기                                                       +"),
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
