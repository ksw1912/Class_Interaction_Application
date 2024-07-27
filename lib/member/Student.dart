import 'package:spaghetti/member/User.dart';

class Student extends User {
  final String department;

  Student({
    required super.id,
    required super.username,
    required super.email,
    required super.password,
    required super.role,
    required this.department,
  });

  // From JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'] ?? "",
      role: json['role'],
      department: json['department'],
    );
  }

  // To JSON
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['department'] = department;
    return data;
  }
}
