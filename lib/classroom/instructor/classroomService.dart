import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spaghetti/ApiUrl.dart';
import 'package:spaghetti/Dialog/Dialogs.dart';
import 'package:spaghetti/classroom/classroom.dart';
import 'package:spaghetti/opinion/Opinion.dart';
import 'package:spaghetti/opinion/OpinionService.dart';
import 'package:spaghetti/opinion/OpinionVote.dart';

class ClassOpinionData {
  // 수업 생성시 옵션 데이터 삭제해야함
  ClassOpinionData({
    required this.content,
    required this.count,
  });

  String content;
  int count;
}

class ClassroomService extends ChangeNotifier {
  final String apiUrl = Apiurl().url;
  final storage = FlutterSecureStorage();
  List<Classroom> classroomList = [];
  List<Opinion> opinions = [];

  List<ClassOpinionData> opinionList = [
    ClassOpinionData(content: '20', count: 20),
    ClassOpinionData(content: '30', count: 30),
    ClassOpinionData(content: '100', count: 100),
    ClassOpinionData(content: '40', count: 40),
  ];

  //필요없는기능 삭제해야함
  createOpinion({required String content, required int count}) {
    ClassOpinionData opinion = ClassOpinionData(content: content, count: count);
    opinionList.add(opinion);
    notifyListeners();
  }

//필요없는기능 삭제해야함
  updateOpinion({required int index, required String content}) {
    ClassOpinionData opinion = opinionList[index];
    opinion.content = content;
    notifyListeners();
  }

//필요없는기능 삭제해야함
  deleteOpinion({required int index}) {
    opinionList.removeAt(index);
    notifyListeners();
  }

//필요없는기능 삭제해야함
  deleteClassRoom() {
    notifyListeners();
  }

  int maxCount(List<OpinionVote> opinion) {
    int maxIndex = 0;
    for (int i = 1; i < opinion.length; i++) {
      if (opinion[i].count > opinion[maxIndex].count) {
        maxIndex = i;
      }
    }
    return maxIndex;
  }

  List<Classroom> get classroomLists => classroomList;

  void setClassrooms(List<Classroom> classrooms) {
    classroomList = classrooms;
    notifyListeners();
  }

  //@controller("/classrooms")
  Future<void> classroomCreate(BuildContext context, String className,
      List<Opinion> opinionList, OpinionService opinionService) async {
    List<String> ops = [];

    for (var op in opinionList) {
      ops.add(op.opinion);
    }

    if (className.isEmpty || className == null) {
      await Dialogs.showErrorDialog(context, '수업명을 입력해주세요.');
      return;
    }

    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt == null) {
      //토큰이 존재하지 않을 때 첫페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return;
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${jwt}',
    };

    var body = jsonEncode({
      'className': className,
      'ops': ops,
    });
    try {
      var response = await http.post(
        Uri.parse('$apiUrl/classrooms'),
        headers: headers,
        body: body,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("응답성공 ");
        Classroom classroom =
            Classroom.fromJson_notArray(responseBody['classroom']);

        List<Opinion> opinions = (responseBody['opinions'] as List)
            .map((opinionJson) => Opinion.fromJson(opinionJson))
            .toList();

        classroomList.add(classroom);
        for (int i = 0; i < opinions.length; i++) {
          opinionService.updateOpinion(i, opinions[i]);
        }
        notifyListeners();
      } else {
        await Dialogs.showErrorDialog(context, '기존 수업이 존재합니다.');
      }
    } catch (exception) {
      print(exception);
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  //날짜 string 타입으로변환
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

//교수클래스 입장
  Future<Classroom?> classroomOpinions(
    BuildContext context,
    String classId,
  ) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt == null) {
      //토큰이 존재하지 않을 때 첫페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return null;
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${jwt}',
    };

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/classrooms/classroomEnter/$classId'),
        headers: headers,
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("응답성공 ");
        Classroom classroom =
            Classroom.fromJson_notArray(responseBody['classroom']);

        List<Opinion> opinions = (responseBody['opinions'] as List)
            .map((opinionJson) => Opinion.fromJson(opinionJson))
            .toList();

        var opinionService =
            Provider.of<OpinionService>(context, listen: false);
        if (opinions.length > 0) {
          opinionService.initializeOpinionList();
        }
        for (int i = 0; i < opinions.length; i++) {
          opinionService.addOpinion(opinion: opinions[i]);
          print(opinions[i].opinion);
        }

        notifyListeners();
        return classroom;
      } else {
        await Dialogs.showErrorDialog(context, ' 수업 입장 중 오류 발생');
      }
    } catch (exception) {
      print(exception);
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  //학생 특정수업입장(pin번호 입력으로)

  Future<Classroom?> studentEnterClassPin(
    BuildContext context,
    String classNumber,
  ) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt == null) {
      //토큰이 존재하지 않을 때 첫페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return null;
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${jwt}',
    };

    try {
      var response = await http.get(
        Uri.parse('$apiUrl/classrooms/classroomEnter/pin/$classNumber'),
        headers: headers,
      );
      print(classNumber);
      print(response.statusCode);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("응답성공 ");
        Classroom classroom =
            Classroom.fromJson_notArray(responseBody['classroom']);

        List<Opinion> opinions = (responseBody['opinions'] as List)
            .map((opinionJson) => Opinion.fromJson(opinionJson))
            .toList();

        var opinionService =
            Provider.of<OpinionService>(context, listen: false);
        if (opinions.length > 0) {
          opinionService.initializeOpinionList();
        }
        for (int i = 0; i < opinions.length; i++) {
          opinionService.addOpinion(opinion: opinions[i]);
          print(opinions[i].opinion);
        }

        notifyListeners();
        return classroom;
      } else {
        await Dialogs.showErrorDialog(context, '오류발생');
      }
    } catch (exception) {
      print(exception);
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  //수업삭제
  Future<void> classroomDelete(
    BuildContext context,
    String classId,
  ) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt == null) {
      //토큰이 존재하지 않을 때 첫페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return;
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': '${jwt}',
    };

    try {
      var response = await http.delete(
        Uri.parse('$apiUrl/classrooms/classDelete/$classId'),
        headers: headers,
      );

      print(response.statusCode);
      if (response.statusCode == 200) {
        print("응답성공 ");
        for (int i = 0; i < classroomList.length; i++) {
          print(i);
          if (classroomList[i].classId == classId) {
            classroomList.removeAt(i);
            notifyListeners();
          }
        }

        var opinionService =
            Provider.of<OpinionService>(context, listen: false);
        opinionService.deleteAll();
        notifyListeners();
      } else {
        await Dialogs.showErrorDialog(context, '오류발생');
      }
    } catch (exception) {
      print(exception);
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  Future<void> classroomMakePin(
      BuildContext context, String classId, String classNumber) async {
    // JWT 토큰을 저장소에서 읽어오기
    String? jwt = await storage.read(key: 'Authorization');

    if (jwt == null) {
      // 토큰이 존재하지 않을 때 첫 페이지로 이동
      await Dialogs.showErrorDialog(context, '로그인 시간이 만료되었습니다.');
      Navigator.of(context).pushReplacementNamed('/Loginpage');
      return;
    }

    // 헤더에 JWT 토큰 추가
    var headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': jwt,
    };

    try {
      var response = await http.get(
        Uri.parse('$apiUrl/classrooms/classroomMakePin/$classId/$classNumber'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("응답 성공");
      } else {
        await Dialogs.showErrorDialog(context, '오류 발생');
      }
    } catch (exception) {
      print(exception);
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }
}
