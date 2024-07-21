import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';

import 'classCreatePage.dart';

class EditClassDialog extends StatefulWidget {
  final int index;
  final String classId;

  EditClassDialog({required this.index, required this.classId});
  @override
  _EditClassDialogState createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  ScrollController? _scrollController;
  var className = "";
  List<String>? ops;

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
        List<Opinion> opinionList = opinionService.opinionList;

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
              height: screenHeight * 0.7,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Text(
                          '수업을 수정해주세요.',
                          style: TextStyle(fontSize: screenWidth * 0.05),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
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
                          onChanged: (value) {
                            className = value;
                          },
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '수업 의견을 수정해주세요.',
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () {
                                opinionService.addOpinion(
                                    opinion: Opinion(opinion: ""));
                              },
                            ),
                          ],
                        ),
                        Divider(color: Colors.black),
                        SizedBox(height: screenHeight * 0.02),
                        Container(
                          height: screenHeight * 0.25,
                          child: Scrollbar(
                            thumbVisibility: false,
                            controller: _scrollController,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              itemCount: opinionList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: screenHeight * 0.07,
                                          child: TextField(
                                            onChanged: (value) {
                                              opinionService.updateOpinion(
                                                  index,
                                                  Opinion(opinion: value));
                                            },
                                            decoration: InputDecoration(
                                              fillColor: Color.fromARGB(
                                                  255, 214, 214, 214),
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
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          opinionService.deleteOpinion(index);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.1, vertical: 10),
                    child: Column(
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(192, 5, 165, 0),
                            surfaceTintColor: Color.fromARGB(192, 5, 165, 0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            await classService.classroomCreate(context,
                                className, opinionList ?? [], opinionService);
                            Navigator.pop(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "수업 수정하기",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "+",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(192, 255, 0, 0),
                            surfaceTintColor: Color.fromARGB(192, 255, 0, 0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
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
                                        '수업을 삭제하시겠습니까?',
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
                                                // 수업 삭제 기능을 여기에 추가
                                                classService.classroomDelete(
                                                    context,
                                                    widget.classId,
                                                    widget.index);
                                                Navigator.of(context)
                                                    .pop(); // 모달 닫기
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        ClassCreatePage(),
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
                                              child: Text('삭제'),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "수업 삭제하기",
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                "-",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
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
      },
    );
  }
}
