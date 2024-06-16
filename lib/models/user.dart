class User {
  final String id;
  final String email;
  final String fullname;
  final String role;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.fullname,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['_id'] ?? '',
      email: json['user']['email'] ?? '',
      fullname: json['user']['fullname'] ?? '',
      role: json['user']['role'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
