
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';

import 'classCreatePage.dart';

class EditClassDialog extends StatefulWidget {
  final Classroom? classRoomData;
  Websocket? websocket;
  
  EditClassDialog(
      {super.key, required this.classRoomData, required this.websocket});
  @override
  _EditClassDialogState createState() => _EditClassDialogState();
}

class _EditClassDialogState extends State<EditClassDialog> {
  ScrollController? _scrollController;
  List<String>? ops;
  List<String>? opinion;
  List<Opinion>? opinionList;
  String? jwt;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final opinionService =
          Provider.of<OpinionService>(context, listen: false);
      setState(() {
        opinionList = opinionService.opinionList;
        opinion = opinionList?.map((opinion) => opinion.opinion).toList();
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ClassroomService, OpinionService>(
      builder: (context, classService, opinionService, child) {
        TextEditingController titleValue =
            TextEditingController(text: widget.classRoomData!.className);

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
                        TextFormField(
                          controller: titleValue,
                          decoration: InputDecoration(
                            fillColor: Color(0xfff7f8fc),
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            widget.classRoomData!.className = value;
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
                                setState(() {
                                  opinion?.add("");
                                });
                              },
                            ),
                          ],
                        ),
                        Divider(color: Colors.black),
                        SizedBox(height: screenHeight * 0.02),
                        SizedBox(
                          height: screenHeight * 0.25,
                          child: Scrollbar(
                            thumbVisibility: false,
                            controller: _scrollController,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              itemCount: opinion?.length ?? 0,
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
                                          child: TextFormField(
                                            onChanged: (value) {
                                              if (opinion != null) {
                                                opinion![index] = value;
                                              }
                                            },
                                            controller: TextEditingController(
                                                text: opinion?[index]),
                                            decoration: InputDecoration(
                                              fillColor: Color(0xfff7f8fc),
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
                                          setState(() {
                                            opinion?.removeAt(index);
                                          });
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
                            backgroundColor: Color(0xff789bd0),
                            surfaceTintColor: Color(0xff789bd0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (widget.classRoomData!.className == "") {
                              // AlertDialog 표시
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("제목을 입력해주세요"),
                                    actions: [
                                      // 가운데 정렬을 위한 Row 위젯 사용
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 다이얼로그 닫기
                                            },
                                            child: Text("확인"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (opinion!
                                .any((item) => item.isEmpty)) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("의견을 적어주세요"),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // 다이얼로그 닫기
                                            },
                                            child: Text("확인"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              // 수정하기
                              await classService.editOpinions(
                                  context, widget.classRoomData!, opinion!);

                              await widget.websocket?.sendOpinionUpdate(
                                  Provider.of<OpinionService>(context,
                                          listen: false)
                                      .opinionList);
                              print("진짜 김서원;;;;");
                              Navigator.pop(context);
                            }
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
                            backgroundColor: Color(0xfff7f8fc),
                            surfaceTintColor: Color(0xfff7f8fc),
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
                                                    widget.classRoomData!
                                                        .classId);
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
                                style: TextStyle(color: Color(0xff789bd0)),
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
