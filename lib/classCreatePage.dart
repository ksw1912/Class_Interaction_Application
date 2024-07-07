import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'class_Service.dart';

class ClassCreatePage extends StatefulWidget {
  const ClassCreatePage({super.key});

  @override
  State<ClassCreatePage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ClassCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClassService>(builder: (context, classService, child) {
      // classService로 부터 classList 가져오기
      List<ClassData> classList = classService.classList;

      return Scaffold(
        resizeToAvoidBottomInset: false, //키보드 오버플러우
        body: PageView(
          children: [
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.8, -0.6),
                    child: Image.asset(
                      'assets/images/profil1.png',
                      width: 75,
                      height: 75,
                    ),
                  ),
                  Align(
                    alignment: Alignment(-0.35, -0.55),
                    child: Text('반가워요!', style: TextStyle(fontSize: 15)),
                  ),
                  Align(
                    alignment: Alignment(-0.3, -0.50),
                    child: Text('김서원 대학원생님', style: TextStyle(fontSize: 10)),
                  ),
                  Align(
                    alignment: Alignment(-0.6, -0.3),
                    child: Text('새로운 수업을 생성해 주세요!',
                        style: TextStyle(fontSize: 15)),
                  ),
                  Align(
                    alignment: Alignment(-0.1, -0.17),
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
                  Align(
                    alignment: Alignment(-0.7, 0),
                    child: Text('이전 수업', style: TextStyle(fontSize: 15)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 325.0, left: 50), // ListView 위치 조정
                    child: ListView.builder(
                      itemCount: classList.length,
                      itemBuilder: (content, index) {
                        ClassData classData = classList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: .0),
                          child: Container(
                            alignment: Alignment.centerLeft, // 아이템 정렬
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
                                    builder: (context) =>
                                        const ClassCreatePage(),
                                  ),
                                );
                              },
                              child: Text(
                                classData.content,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

void addDialog(context) {
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
  @override
  Widget build(BuildContext context) {
    // classService로 부터 classList 가져오기
    return Consumer<ClassOpinion>(builder: (context, classOpinion, child) {
      List<ClassOpinionData> opinionList = classOpinion.opinionList;
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        width: double.infinity,
        child: PageView(
          children: [
            Container(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment(-0.56, -0.85),
                    child: Text('수업을 생성해주세요.', style: TextStyle(fontSize: 20)),
                  ),
                  Align(
                    alignment: Alignment(-0.5, -0.2),
                    child:
                        Text('수업 의견을 생성해주세요.', style: TextStyle(fontSize: 17)),
                  ),
                  Align(
                    alignment: Alignment(0, -0.325),
                    child: Container(
                      height: 3,
                      width: 300,
                      color: Colors.black,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(
                      top: 90.0,
                      left: 50,
                      right: 50,
                    ),
                    child: Container(
                      width: 300,
                      height: 50,
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
                  // 플러스 아이콘 버튼
                  Align(
                      alignment: Alignment(0.7, -0.2),
                      child: IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          classOpinion.createOpinion(content: '');
                        },
                      )),
                  // 버튼 눌렀을때 의견 생성

                  Padding(
                    padding: const EdgeInsets.only(
                        top: 220.0, left: 50), // ListView 위치 조정
                    child: ListView.builder(
                      itemCount: opinionList.length,
                      itemBuilder: (content, index) {
                        ClassOpinionData classOpinionData = opinionList[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: .50),
                          child: Container(
                            alignment: Alignment.centerLeft, // 아이템 정렬
                            child: Container(
                              width: 300,
                              height: 40,
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
                                  hintText: '의견을 적어주세요',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
