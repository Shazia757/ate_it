class User {
  final int id;
  final String username;
  final String email;
  final String role;
  // active addresses might be a list or null
  final List<dynamic>? addresses;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.addresses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      addresses: json['addresses'] ?? [],
    );
  }
}
