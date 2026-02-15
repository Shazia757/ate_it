import 'package:ate_it/model/user_model.dart';

class LoginResponse {
  bool? status;
  String? message;
  User? data;

  LoginResponse({
    required this.status,
    required this.data,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      data: json['data'] != null
          ? User.fromJson(json['data'] as Map<String, dynamic>)
          : User(),
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }

  @override
  String toString() {
    return 'status:$status,message:$message';
  }
}

class GeneralResponse {
  bool? status;
  String? message;

  GeneralResponse({required this.status, this.message});

  factory GeneralResponse.fromJson(Map<String, dynamic> json) {
    return GeneralResponse(
        status: json['status'] as bool?, message: json['message'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'message': message};
  }
}
