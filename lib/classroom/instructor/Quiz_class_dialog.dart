import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/classroom/instructor/classroomService.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';

class QuizClassDialog extends StatefulWidget {
  @override
  _QuizClassDialogState createState() => _QuizClassDialogState();
}

class _QuizClassDialogState extends State<QuizClassDialog> {
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
            child: PageView(
              children: [
                Container(
                  child: Stack(
                    children: [
                      Positioned(
                        left: screenWidth * 0.12,
                        top: screenHeight * 0.05,
                        child: Text('퀴즈를 생성해주세요.',
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
                              itemCount: 5,
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
                                            onChanged: (value) {},
                                            // controller: TextEditingController(
                                            //     text: ),
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
                                              hintText: '내용을 적어주세요',
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          setState(() {});
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
                        top: screenHeight * 0.4,
                        child: Container(
                          width: screenWidth * 0.2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(192, 5, 165, 0),
                              surfaceTintColor: Color.fromARGB(192, 5, 165, 0),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {},
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
