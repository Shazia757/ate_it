import 'package:ate_it/model/restaurant_model.dart';

class OrderResponse {
  bool? status;
  String? message;
  List<OrderDetailedResponse>? data;

  OrderResponse({
    required this.status,
    required this.data,
    this.message,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => OrderDetailedResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: json['status'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data
          ?.map(
            (e) => e.toJson,
          )
          .toList()
    };
  }
}

class OrderModel {
  final int id;
  final String orderId;
  final String? restaurantName;
  final String totalAmount;
  final String status;
  final String? createdAt;

  OrderModel({
    required this.id,
    required this.orderId,
    this.restaurantName,
    required this.totalAmount,
    required this.status,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderId: json['order_id'],
      restaurantName: json['restaurant_name'],
      totalAmount: json['total_amount'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}

class OrderDetailedResponse {
  int? id;
  List<OrderItem>? items;
  RestaurantDetail? customer;
  RestaurantStatus? restaurant;
  String? orderId;
  String? status;
  String? totalAmount;
  String? platformFee;
  String? deliveryFee;
  DateTime? createdAt;
  DateTime? updatedAt;

  OrderDetailedResponse({
    this.id,
    this.orderId,
    this.status,
    this.totalAmount,
    this.platformFee,
    this.deliveryFee,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.restaurant,
    this.items,
  });

  factory OrderDetailedResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailedResponse(
      id: json['id'],
      orderId: json['order_id'],
      status: json['status'],
      totalAmount: json['total_amount'],
      platformFee: json['platform_fee'],
      deliveryFee: json['delivery_fee'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      customer: RestaurantDetail.fromJson(json['customer']),
      restaurant: RestaurantStatus.fromJson(json['restaurant']),
      items: (json['items'] as List)
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'status': status,
      'total_amount': totalAmount,
      'platform_fee': platformFee,
      'delivery_fee': deliveryFee,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'customer': customer?.toJson(),
      'restaurant': restaurant?.toJson(),
      'items': items?.map((e) => e.toJson()),
    };
  }
}

class OrderItem {
  final FoodItem foodItem;
  final int quantity;
  final String priceAtTimeOfOrder;

  OrderItem({
    required this.foodItem,
    required this.quantity,
    required this.priceAtTimeOfOrder,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      foodItem: FoodItem.fromJson(json['food_item']),
      quantity: json['quantity'],
      priceAtTimeOfOrder: json['price_at_time_of_order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'food_item': foodItem,
      'quantity': quantity,
      'price_at_time_of_order': priceAtTimeOfOrder
    };
  }
}

// class OrderResponse {
//   final String? orderId;
//   final String status;
//   final double totalAmount;
//   final DateTime createdAt;
//   final String? restaurantName;
//   final String? restaurantImage;
//   final List<OrderItem>? items;

//   OrderResponse({
//     this.orderId,
//     required this.status,
//     required this.totalAmount,
//     required this.createdAt,
//     this.restaurantName,
//     this.restaurantImage,
//     this.items,
//   });

//   factory OrderResponse.fromJson(Map<String, dynamic> json) {
//     return OrderResponse(
//       orderId: json['restaurant']['order_id'],
//       status: json['status'],
//       totalAmount: double.parse(json['total_amount']),
//       createdAt: DateTime.parse(json['created_at']),
//       restaurantName: json['restaurant']['restaurant_name'],
//       restaurantImage: json['restaurant']['image'],
//       items: (json['items'] as List)
//           .map((item) => OrderItem.fromJson(item))
//           .toList(),
//     );
//   }
// }
