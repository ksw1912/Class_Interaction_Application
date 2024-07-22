import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'AuthService.dart';

class Joinmember extends StatefulWidget {
  const Joinmember({super.key});

  @override
  State<Joinmember> createState() => _JoinmemberState();
}

class _JoinmemberState extends State<Joinmember> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  int? selectedRadio = -1; // 초기값을 -1로 설정하여 선택되지 않음을 명확히 표시

  var role = ""; // 0이면 교수 1이면 학생
  var username = ""; // 유저 아이디
  var password = ""; // 유저 비밀번호
  var email = ""; // 유저 이메일
  var department = ""; // 부서??
  var PWCheck1 = '1';
  var PWCheck2 = '2';
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  void tapped(int step) {
    setState(() => _currentStep = step);
  }

  void continued() {
    if (_currentStep == 0 &&
        (!_formKey1.currentState!.validate() || selectedRadio == -1)) {
      return;
    } else if (_currentStep == 1 && !_formKey2.currentState!.validate()) {
      return;
    } else if (_currentStep == 2 && !_formKey3.currentState!.validate()) {
      return;
    } else if (_currentStep == 3 && !_formKey4.currentState!.validate()) {
      return;
    } else if (_currentStep == 4 && !_formKey5.currentState!.validate()) {
      return;
    }

    if (_currentStep < 4) {
      setState(() => _currentStep += 1);
    }
  }

  void cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectjob = ["교수", "학생"];
    var response;
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 60, 0),
        child: Theme(
          data: ThemeData(
              // primaryColor: Colors.green,
              //  colorScheme: ColorScheme.fromSwatch()
              //  .copyWith(secondary: Colors.green), // 전체 테마의 강조 색상
              ),
          child: Stepper(
            type: stepperType,
            physics: ScrollPhysics(),
            currentStep: _currentStep,
            onStepTapped: (step) => tapped(step),
            onStepContinue: continued,
            onStepCancel: cancel,
            steps: <Step>[
              Step(
                title: Text('Role'),
                subtitle: Text('자신의 역할을 선택해주세요'),
                content: Form(
                  key: _formKey1,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          itemCount: selectjob.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => selectedRadio = index);
                                  if (index == 1) {
                                    // 교수인지 학생인지 정보
                                    role = 'student';
                                  } else {
                                    role = 'instructor';
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(selectjob[index]),
                                      ),
                                      Radio<int>(
                                        value: index,
                                        groupValue: selectedRadio,
                                        onChanged: (
                                          int? value,
                                        ) {
                                          setState(() => selectedRadio = value);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Email'),
                subtitle: Text('이메일을 입력해주세요'),
                content: Form(
                  key: _formKey2,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          email = value!; // 이메일 저장

                          if (value == null || value.isEmpty) {
                            return '이메일 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          email = _emailController.text;
                          response = await AuthService().checkEmail(email);
                          if (response.statusCode != 200) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("사용가능한 이메일 입니다"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        setState(() {
                                          _currentStep += 1;
                                        });
                                        //continued();
                                      },
                                      child: Text("확인"),
                                    )
                                  ],
                                );
                              },
                            );
                          } else {
                            // 이메일 중복

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  content: Text("중복된 이메일 입니다"),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("닫기"),
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: Text('중복확인'),
                      ),
                    ],
                  ),
                ),
                isActive: _currentStep >= 2,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('PassWord'),
                subtitle: Text('비밀번호를 입력해주세요'),
                content: Form(
                  key: _formKey3,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'PassWord'),
                        validator: (value) {
                          password = value!; // 비밀번호 저장
                          PWCheck1 = value;
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (value) {
                          PWCheck2 = value!;
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          // ignore: curly_braces_in_flow_control_structures
                          else if (PWCheck1 != PWCheck2) {
                            return '비밀번호가 다릅니다';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                isActive: _currentStep >= 3,
                state:
                    _currentStep >= 3 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Username or Department'),
                subtitle: Text('이름과 학과을 입력해주세요'),
                content: Form(
                  key: _formKey4,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          username = value!; // 이름
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Department'),
                        validator: (value) {
                          department = value!; // 학과
                          if (value == null || value.isEmpty) {
                            return '학과를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                isActive: _currentStep >= 4,
                state:
                    _currentStep >= 4 ? StepState.complete : StepState.disabled,
              ),
              Step(
                title: Text('Join'),
                subtitle: Text('가입을 완료해 주세요!'),
                content: Form(
                  key: _formKey5,
                  child: ElevatedButton(
                    onPressed: () async {
                      var response = await AuthService()
                          .join(username, email, password, role, department);
                      if (response.statusCode == 200) {
                        _formKey1.currentState!.save();
                        _formKey2.currentState!.save();
                        _formKey3.currentState!.save();
                        _formKey4.currentState!.save();
                        //가입완료
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("회원가입 성공"),
                              content: Text("회원가입이 성공적으로 완료"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("확인"),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        // 가입 실패

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("회원가입 실패1"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("닫기"),
                                )
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Text('가입하기'),
                  ),
                ),
              )
            ],
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              if (_currentStep == 4) {
                return Container();
              } else if (_currentStep == 1) {
                return Container();
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      child: Text('OK'),
                    ),
                    ElevatedButton(
                      onPressed: details.onStepCancel,
                      child: Text('Cancel'),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
