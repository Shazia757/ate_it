import 'package:flutter/widgets.dart';

class RestaurantResponse {
  bool? status;
  String? message;
  RestaurantData? data;

  RestaurantResponse({
    this.status,
    this.message,
    this.data,
  });
  factory RestaurantResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantResponse(
      status: json['status'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? RestaurantData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class RestaurantData {
  int? count;
  String? next;
  String? previous;
  List<RestaurantStatus>? results;

  RestaurantData({this.count, this.next, this.previous, this.results});

  factory RestaurantData.fromJson(Map<String, dynamic> json) {
    return RestaurantData(
      count: json['count'] as int?,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => RestaurantStatus.fromJson(e as Map<String, dynamic>))
          .toList(),   
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results?.map((e) => e.toJson()).toList(),
    };
  }
}

class RestaurantStatus {
  int? id;
  RestaurantDetail? user;
  String? restaurantName;
  String? description;
  bool isOpen;
  Image? image;
  bool? isApproved;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  int? address;

  RestaurantStatus({
    this.id,
    this.accountNumber,
    this.address,
    this.bankName,
    this.description,
    this.ifscCode,
    this.image,
    this.isApproved,
    required this.isOpen,
    this.restaurantName,
    this.user,
  });

  factory RestaurantStatus.fromJson(Map<String, dynamic> json) {
    return RestaurantStatus(
        id: json['id'] as int?,
        accountNumber: json['account_number'],
        address: json['address'] as int?,
        bankName: json['bank_name'],
        description: json['description'],
        ifscCode: json['ifsc_code'],
        image: json['image'],
        isApproved: json['is_approved'],
        isOpen: json['is_open'],
        restaurantName: json['restaurant_name'],
        user: json['user'] != null
            ? RestaurantDetail.fromJson(json['user'])
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_number': accountNumber,
      'address': address,
      'bank_name': bankName,
      'description': description,
      'ifsc_code': ifscCode,
      'image': image,
      'is_approved': isApproved,
      'is_open': isOpen,
      'restaurant_name': restaurantName,
      'user': user?.toJson(),
    };
  }
}

class FoodItem {
  final int id;
  final String name;
  final String price;
  final String? originalPrice;
  final bool isAvailable;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.isAvailable,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      originalPrice: json['original_price'],
      isAvailable: json['is_available'],
    );
  }
}

class RestaurantDetail {
  int? id;
  String? userName;
  String? email;
  String? role;
  String? phoneNumber;
  String? firstName;
  String? lastName;

  RestaurantDetail({
    this.id,
    this.userName,
    this.role,
    this.email,
    this.firstName,
    this.lastName,
    this.phoneNumber,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        email: json['email'],
        phoneNumber: json['phone_number'],
        role: json['role'],
        userName: json['username']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_number': phoneNumber,
      'role': role,
      'username': userName,
    };
  }
}
