// Farid Dhiya Fairuz - 247006111058 - B

class User {
  final int id;
  final String username;
  final String email;
  final String token;

  User({required this.id, required this.username, required this.email, required this.token});

  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      token: token,
    );
  }
}
