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
