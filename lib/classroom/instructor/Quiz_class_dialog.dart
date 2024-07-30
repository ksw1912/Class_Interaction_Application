import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Dialog/CicularProgress.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/quiz/Quiz.dart';
import 'package:spaghetti/quiz/QuizService.dart';

class QuizClassDialog extends StatefulWidget {
  Classroom? classroom;
  Websocket? websocket;
  QuizClassDialog(this.classroom, this.websocket, {super.key});
  @override
  _QuizClassDialogState createState() => _QuizClassDialogState();
}

class _QuizClassDialogState extends State<QuizClassDialog> {
  ScrollController? _scrollController;
  bool isLoading = false;
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
    return Consumer2<ClassroomService, QuizService>(
        builder: (context, classService, quizService, child) {
      List<TextEditingController> controllers = [];
      List<Quiz> quizList = quizService.quizList;

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
            child: PageView(
              children: [
                Container(
                  child: Stack(
                    children: [
                      if (isLoading) CircularProgress.build(),
                      Positioned(
                        left: screenWidth * 0.12,
                        top: screenHeight * 0.05,
                        child: Text('퀴즈를 생성해주세요.',
                            style: TextStyle(fontSize: screenWidth * 0.05)),
                      ),
                      Positioned(
                        left: screenWidth * 0.775,
                        top: screenHeight * 0.04,
                        child: IconButton(
                          icon: Icon(Icons.add_circle_outline),
                          onPressed: () {
                            setState(() {
                              quizList.add(Quiz("", widget.classroom, ""));
                            });
                          },
                        ),
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
                        top: screenHeight * 0.15,
                        right: screenWidth * 0.1,
                        bottom: screenHeight * 0.15,
                        child: Scrollbar(
                          thumbVisibility: false, //스크롤할때만 손잡이가 보임
                          controller: _scrollController,
                          child: Container(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.zero,
                              itemCount: quizList.length,
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
                                              quizList[index].question = value;
                                            },
                                            controller: TextEditingController(
                                                text: quizList[index].question),
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
                                              hintText: '내용을 적어주세요',
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {
                                            quizList.removeAt(index);
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
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.6,
                        child: SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.06,
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
                              List<Quiz> quizs = [];
                              for (int i = 0; i < quizList.length; i++) {
                                //1. 입력한 배열을 검색하여 존재여부 판단
                                if (quizList[i].question != null) {
                                  quizs.add(quizList[i]); //존재할경우 quizs라는 배열에 삽입
                                }
                              }
                              if (quizs.isNotEmpty) {
                                //배열이 존재할경우 create
                                setState(() {
                                  isLoading = true;
                                });
                                quizService.quizCreate(
                                    context,
                                    widget.classroom!.classId,
                                    quizList,
                                    widget.websocket);
                                setState(() {
                                  isLoading = false;
                                });
                                Navigator.pop(context);
                              } else {
                                //배열이 존재하지 않을 경우 Dialog
                                await Dialogs.showErrorDialog(
                                    context, "퀴즈를 입력해주세요");
                              }
                            },
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
