class User {
  int? id;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? role;
  String? phoneNumber;
  String? state;
  String? district;
  String? city;
  String? pincode;

  User({
    this.id,
    this.username,
    this.email,
    this.role,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.city,
    this.district,
    this.pincode,
    this.state,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'] as int?,
        username: json['username'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        state: json['state'],
        district: json['district'],
        city: json['city'],
        pincode: json['pincode'],
        role: json['role'],
        phoneNumber: json['phone_number']);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'role': role,
      'phone_number': phoneNumber,
      'state': state,
      'city': city,
      'district': district,
      'pincode': pincode,
    };
  }
}
