class User {
  int? id;
  String? username;
  String? email;
  String? role;
  String? password;
  List<dynamic>? addresses;

  User(
      {this.id,
      this.username,
      this.email,
      this.role,
      this.addresses,
      this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      role: json['role'],
      addresses: json['addresses'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'password': password,
    };
  }
}
