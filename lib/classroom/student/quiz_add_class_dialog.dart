import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/Dialog/CicularProgress.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/Websocket/Websocket.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/quiz/Quiz.dart';
import 'package:spaghetti/quiz/QuizService.dart';

class AddClassDialog extends StatefulWidget {
  Websocket? websocket;
  AddClassDialog(this.websocket, {super.key});
  @override
  _AddClassDialogState createState() => _AddClassDialogState();
}

class _AddClassDialogState extends State<AddClassDialog> {
  ScrollController? _scrollController;
  int? selectedRadio = 0;
  bool isLoading = false;
  bool button = true;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    button = true;
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    isLoading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ClassroomService, QuizService>(
        builder: (context, classService, quizService, child) {
      List<Quiz> quizList = quizService.quizList;
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
            height: screenHeight * 0.5,
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
                        child: Text('퀴즈를 풀어주세요.',
                            style: TextStyle(fontSize: screenWidth * 0.05)),
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
                        top: screenHeight * 0.11, // "이전 수업" 텍스트 아래 30px
                        left: screenWidth * 0.1,
                        child: Scrollbar(
                          thumbVisibility: true,
                          controller: _scrollController,
                          child: SingleChildScrollView(
                            child: SizedBox(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.3,
                              child: quizList.isNotEmpty
                                  ? ListView.builder(
                                      padding:
                                          EdgeInsets.zero, // ListView의 패딩을 없앰
                                      itemCount: quizList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(
                                                  () => selectedRadio = index);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors
                                                        .grey), // 테두리 선 추가
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16.0),
                                                    child: Text(quizList[index]
                                                            .question ??
                                                        ""),
                                                  ),
                                                  Radio<int>(
                                                    value: index,
                                                    groupValue: selectedRadio,
                                                    onChanged: (int? value) {
                                                      setState(() =>
                                                          selectedRadio =
                                                              value);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text('퀴즈가 없습니다.'),
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: screenWidth * 0.1,
                        top: screenHeight * 0.4,
                        child: SizedBox(
                          width: screenWidth * 0.8,
                          height: screenHeight * 0.06, // 화면 너비의 80%
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff789bd0),
                              surfaceTintColor: Color(0xff789bd0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: button
                                ? () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (selectedRadio != null) {
                                      widget.websocket?.sendQuiz(
                                          quizList[selectedRadio ?? 0]);
                                      setState(() {
                                        isLoading = false;
                                        button = false; /////// 무한 퀴즈 할수있음
                                      });
                                      Navigator.pop(context); //// 요기도
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Dialogs.showErrorDialog(context, "답 맞춰라");
                                    }
                                  }
                                : null,
                            child: Text(
                              "답안 제출",
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
