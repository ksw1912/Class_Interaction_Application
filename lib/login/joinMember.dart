import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Joinmember extends StatefulWidget {
  const Joinmember({super.key});

  @override
  State<Joinmember> createState() => _JoinmemberState();
}

class _JoinmemberState extends State<Joinmember> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;
  int? selectedRadio = -1; // 초기값을 -1로 설정하여 선택되지 않음을 명확히 표시

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();

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
    }
    if (_currentStep < 3) {
      setState(() => _currentStep += 1);
    }
  }

  void cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> selectjob = ["교수", "학생"];
    return Scaffold(
      appBar: AppBar(title: Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
        child: Stepper(
          type: stepperType,
          physics: ScrollPhysics(),
          currentStep: _currentStep,
          onStepTapped: (step) => tapped(step),
          onStepContinue: continued,
          onStepCancel: cancel,
          steps: <Step>[
            Step(
              title: Text('Account Type'),
              subtitle: Text('Select Professor or Student'),
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
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedRadio = index);
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
                                      onChanged: (int? value) {
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
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Account'),
              subtitle: Text('Enter your ID and Password'),
              content: Form(
                key: _formKey2,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'ID',
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        focusedErrorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '아이디를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Password'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 1,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Address'),
              content: Form(
                key: _formKey3,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Home Address'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '주소를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Postcode'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '우편번호를 입력해주세요';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 2,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Mobile Number'),
              content: Form(
                key: _formKey4,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Mobile Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '휴대폰 번호를 입력해주세요';
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
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
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
          },
        ),
      ),
    );
  }
}
