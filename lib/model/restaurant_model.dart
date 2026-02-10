class Restaurant {
  final int id;
  final String name;
  final String? description;
  final bool isOpen;
  final String? addressDetails;

  Restaurant({
    required this.id,
    required this.name,
    this.description,
    required this.isOpen,
    this.addressDetails,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['restaurant_name'],
      description: json['description'],
      isOpen: json['is_open'],
      addressDetails: json['address_details'],
    );
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
