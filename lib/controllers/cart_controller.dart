import 'package:ate_it/model/restaurant_model.dart';
// import 'package:ate_it/services/api.dart';
import 'package:ate_it/controllers/wallet_controller.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final WalletController c = Get.put(WalletController());

  var cartItems = <FoodItem, int>{}.obs;
  var restaurantId = (-1).obs;
  var restaurantName = ''.obs;

  double get totalAmount {
    double total = 0.0;
    cartItems.forEach((item, quantity) {
      total += (double.tryParse(item.price) ?? 0.0) * quantity;
    });
    return total;
  }

  void addToCart(FoodItem item, int restaurantId, String? restaurantName) {
    if (this.restaurantId.value != -1 &&
        this.restaurantId.value != restaurantId) {
      Get.defaultDialog(
        title: "Start new cart?",
        middleText:
            "Adding items from a different restaurant will clear your current cart.",
        textConfirm: "Yes",
        textCancel: "No",
        onConfirm: () {
          clearCart();
          Get.back();
          _addItem(item, restaurantId, restaurantName);
        },
      );
    } else {
      _addItem(item, restaurantId, restaurantName);
    }
  }

  void _addItem(FoodItem item, int rId, String? rName) {
    restaurantId.value = rId;
    restaurantName.value = rName ?? '';

    FoodItem? existingItem;
    for (var key in cartItems.keys) {
      if (key.id == item.id) {
        existingItem = key;
      }
    }

    if (existingItem != null) {
      cartItems[existingItem] = (cartItems[existingItem] ?? 0) + 1;
    } else {
      cartItems[item] = 1;
    }

    cartItems.refresh();
    Get.snackbar('Added', '${item.name} added to cart');
  }

  void removeFromCart(FoodItem item) {
    FoodItem? existingItem;
    for (var key in cartItems.keys) {
      if (key.id == item.id) {
        existingItem = key;
      }
    }

    if (existingItem != null) {
      if (cartItems[existingItem]! > 1) {
        cartItems[existingItem] = cartItems[existingItem]! - 1;
      } else {
        cartItems.remove(existingItem);
      }
    }
    if (cartItems.isEmpty) {
      restaurantId.value = -1;
      restaurantName.value = '';
    }
    cartItems.refresh();
  }

  void clearCart() {
    cartItems.clear();
    restaurantId.value = -1;
    restaurantName.value = '';
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) return;

    if (c.balance.value < totalAmount) {
      Get.snackbar("Error", "Insufficient wallet balance. Please top up.");
      return;
    }

    List<Map<String, dynamic>> itemsPayload = [];
    cartItems.forEach((item, qty) {
      itemsPayload
          .add({"food_item_id": item.id, "quantity": qty, "price": item.price});
    });

    Map<String, dynamic> orderData = {
      "restaurant_id": restaurantId.value,
      "items": itemsPayload
    };

    // bool success = c.deductBalance(totalAmount);
    // if (!success) {
    //   Get.snackbar("Error", "Transaction failed.");
    //   return;
    // }

    var order = await ApiService().createOrder(orderData);
    if (order != null) {
      Get.snackbar(
          "Success", "Order placed successfully! ID: ${order.orderId}");
      clearCart();
      Get.back();
    } else {
      c.requestTopup(totalAmount);
      Get.snackbar("Error", "Failed to place order. Amount refunded.");
    }
  }
}
