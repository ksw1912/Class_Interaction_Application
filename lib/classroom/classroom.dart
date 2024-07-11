class Classroom {
  String classId;
  String className;
  String id;
  String instructorName;
  DateTime date;

  Classroom(
      {required this.classId,
      required this.className,
      required this.id,
      required this.instructorName,
      required this.date});

  Map<String, dynamic> toJson() => { //Encoding
        'classId': classId,
        'className': className,
        'id': id,
        'instructorName': instructorName,
        'date': date
      };
  Classroom.fromJson(Map<String, dynamic> json) //Decoding
      : classId = json['classId'],
        className = json['className'],
        id = json['id'],
        instructorName = json['instructorName'],
        date = json['date'];
}
