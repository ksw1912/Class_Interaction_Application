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

class ClassroomService extends ChangeNotifier {
  final String apiUrl = Apiurl().url;
  final storage = FlutterSecureStorage();
  List<Classroom> classroomList = [];
  List<Opinion> opinions = [];

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

  //워치 로그인 Pin 번호 보내기
  Future<void> sendPinToServer(BuildContext context, String pin) async {
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
        Uri.parse('$apiUrl/watch/phone/$pin'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        // 여기에서 필요한 추가 처리를 할 수 있습니다.
      } else {
        // await Dialogs.showErrorDialog(context, '서버 응답 오류');
      }
    } catch (exception) {
      // await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  //@controller("/classrooms")
  Future<void> classroomCreate(BuildContext context, String className,
      List<Opinion> opinionList, OpinionService opinionService) async {
    List<String> ops = [];

    for (var op in opinionList) {
      ops.add(op.opinion);
    }

    if (className.isEmpty) {
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
      'Authorization': jwt,
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

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));

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
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
  }

  //날짜 string 타입으로변환
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
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
      'Authorization': jwt,
    };

    try {
      var response = await http.delete(
        Uri.parse('$apiUrl/classrooms/classDelete/$classId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        for (int i = 0; i < classroomList.length; i++) {
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
      } else {}
    } catch (exception) {
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
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
      'Authorization': jwt,
    };

    try {
      var response = await http.post(
        Uri.parse('$apiUrl/classrooms/classroomEnter/$classId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));

        Classroom classroom =
            Classroom.fromJson_notArray(responseBody['classroom']);

        List<Opinion> opinions = (responseBody['opinions'] as List)
            .map((opinionJson) => Opinion.fromJson(opinionJson))
            .toList();

        if (opinions.isNotEmpty) {
          Provider.of<OpinionService>(context, listen: false)
              .initializeOpinionList();
        }
        for (int i = 0; i < opinions.length; i++) {
          Provider.of<OpinionService>(context, listen: false)
              .addOpinion(opinion: opinions[i]);
        }

        notifyListeners();
        return classroom;
      } else {
        await Dialogs.showErrorDialog(context, ' 수업 입장 중 오류 발생');
      }
    } catch (exception) {
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
    return null;
  }

// 수업의견 수정
  Future<Classroom?> editOpinions(
    BuildContext context,
    Classroom classroom,
    List<String> opinion,
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
      'Authorization': jwt,
    };
    var body = jsonEncode({
      'classroom': classroom,
      'opinion': opinion,
    });

    try {
      var response = await http.put(
        Uri.parse('$apiUrl/classrooms/classroom/update'),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));

        List<Opinion> opinions = (responseBody['opinions'] as List)
            .map((opinionJson) => Opinion.fromJson(opinionJson))
            .toList();

        Provider.of<OpinionService>(context, listen: false)
            .initializeOpinionList();

        for (int i = 0; i < classroomList.length; i++) {
          if (classroomList[i].classId == classroom.classId) {
            classroomList[i].className = classroom.className;
            notifyListeners();
          }
        }
        for (int i = 0; i < opinions.length; i++) {
          Provider.of<OpinionService>(context, listen: false)
              .addOpinion(opinion: opinions[i]);
        }

        notifyListeners();
        return classroom;
      } else {
        await Dialogs.showErrorDialog(context, '의견 수정중 오류 발생');
      }
    } catch (exception) {
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
    return null;
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
      'Authorization': jwt,
    };

    try {
      var response = await http.get(
        Uri.parse('$apiUrl/classrooms/classroomEnter/pin/$classNumber'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody =
            jsonDecode(utf8.decode(response.bodyBytes));

        Classroom classroom =
            Classroom.fromJson_notArray(responseBody['classroom']);

        List<Opinion> opinions = (responseBody['opinions'] as List)
            .map((opinionJson) => Opinion.fromJson(opinionJson))
            .toList();

        var opinionService =
            Provider.of<OpinionService>(context, listen: false);

        if (opinions.isNotEmpty) {
          opinionService.initializeOpinionList();
        }
        for (int i = 0; i < opinions.length; i++) {
          opinionService.addOpinion(opinion: opinions[i]);
        }
        notifyListeners();
        return classroom;
      } else {
        await Dialogs.showErrorDialog(context, '오류발생');
      }
    } catch (exception) {
      await Dialogs.showErrorDialog(context, "서버와의 통신 중 오류가 발생했습니다.");
    }
    return null;
  }
}
