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
  bool _obscureText1 = true;
  bool _obscureText2 = true;
  String emailValidationMessage = ""; // 이메일 확인 메시지
  bool isEmailValid = false; // 이메일 유효성 상태
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

  Future<void> checkEmail(String email) async {
    if (EmailValidator.validate(email)) {
      var response = await AuthService().checkEmail(email);
      if (response.statusCode != 200) {
        setState(() {
          emailValidationMessage = "사용 가능한 이메일입니다.";
          isEmailValid = true;
        });
      } else {
        setState(() {
          emailValidationMessage = "중복된 이메일입니다.";
          isEmailValid = false;
        });
      }
    } else {
      setState(() {
        emailValidationMessage = "유효한 이메일을 입력하세요.";
        isEmailValid = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectjob = ["교수", "학생"];
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 60, 0),
        child: Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color(0xfffbaf01), // active step color
              onPrimary: Colors.white, // active text color
              secondary: Colors.grey, // inactive step color
              onSecondary: Colors.black, // inactive text color
            ),
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
                            borderSide: BorderSide(
                                color:
                                    const Color.fromARGB(255, 255, 255, 255)),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                width: 2.0),
                          ),
                        ),
                        onChanged: (value) {
                          email = value;
                          checkEmail(value);
                        },
                        validator: (value) {
                          email = value!;
                          if (value.isEmpty) {
                            return '이메일 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                        emailValidationMessage,
                        style: TextStyle(
                          color: isEmailValid ? Colors.green : Colors.red,
                        ),
                      ),
                      if (isEmailValid)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xfffbaf01),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: continued,
                            child: Text('OK'),
                          ),
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
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText1
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText1 = !_obscureText1;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          password = value!;
                          PWCheck1 = value;
                          if (value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          return null;
                        },
                        obscureText: _obscureText1,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText2
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText2 = !_obscureText2;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          PWCheck2 = value!;
                          if (value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          } else if (PWCheck1 != PWCheck2) {
                            return '비밀번호가 다릅니다';
                          }
                          return null;
                        },
                        obscureText: _obscureText2,
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
                          username = value!;
                          if (value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Department'),
                        validator: (value) {
                          department = value!;
                          if (value.isEmpty) {
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xfffbaf01),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async {
                      var response = await AuthService()
                          .join(username, email, password, role, department);
                      if (response.statusCode == 200) {
                        _formKey1.currentState!.save();
                        _formKey2.currentState!.save();
                        _formKey3.currentState!.save();
                        _formKey4.currentState!.save();
                        showDialog(
                          context: context,
                          builder: (context) {
                            final screenWidth =
                                MediaQuery.of(context).size.width;
                            final screenHeight =
                                MediaQuery.of(context).size.height;
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: screenWidth * 0.2,
                                    height: screenHeight * 0.2,
                                    child:
                                        Image.asset('assets/images/check.png'),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    "회원가입 완료",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    "에코 클래스룸을 통해\n 수업의 질을 향상시켜보세요.",
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              actions: [
                                Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize:
                                          Size(screenWidth * 0.8, 50), // 버튼을 길게
                                      backgroundColor:
                                          Color(0xfffbaf01), // 버튼 색상
                                      foregroundColor:
                                          Colors.white, // 버튼 텍스트 색상
                                    ),
                                    child: Text(
                                      "확인",
                                      style: TextStyle(
                                        fontFamily: 'NanumEB',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: Text("회원가입 실패"),
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
                    child: Text(
                      '가입하기',
                      style: TextStyle(
                        fontFamily: 'NanumEB',
                      ),
                    ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xfffbaf01),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: details.onStepContinue,
                      child: Text('OK'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff848C99),
                        foregroundColor: Colors.white,
                      ),
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
