import 'package:spaghetti/member/User.dart';

class Student extends User {
  final String department;

  Student({
    required String id,
    required String username,
    required String email,
    required String password,
    required String role,
    required this.department,
  }) : super(
          id: id,
          username: username,
          email: email,
          password: password,
          role: role,
        );

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
