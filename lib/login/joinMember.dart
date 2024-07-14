import 'package:flutter/material.dart';

// 회원가입 페이지
class Joinmember extends StatefulWidget {
  const Joinmember({super.key});

  @override
  State<Joinmember> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Joinmember> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.vertical;

  void tapped(int step) {
    setState(() => _currentStep = step);
  }

  void continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  void cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  @override
  Widget build(BuildContext context) {
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
              title: Text('Account'),
              subtitle: Text('subtitle'),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email Address'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                  ),
                ],
              ),
              isActive: _currentStep >= 0,
              state:
                  _currentStep >= 0 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Address'),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Home Address'),
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Postcode'),
                  ),
                ],
              ),
              isActive: _currentStep >= 1,
              state:
                  _currentStep >= 1 ? StepState.complete : StepState.disabled,
            ),
            Step(
              title: Text('Mobile Number'),
              content: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Mobile Number'),
                  ),
                ],
              ),
              isActive: _currentStep >= 2,
              state:
                  _currentStep >= 2 ? StepState.complete : StepState.disabled,
            ),
          ],
          controlsBuilder: (BuildContext context, ControlsDetails details) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    onPressed: details.onStepContinue, child: Text('OK')),
                ElevatedButton(
                    onPressed: details.onStepCancel, child: Text('Cancel')),
              ],
            );
          },
        ),
      ),
    );
  }
}
