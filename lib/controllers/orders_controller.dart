import 'dart:developer';

import 'package:ate_it/model/order_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  var orders = <OrderDetailedResponse>[].obs;
  var currOrders = <OrderDetailedResponse>[].obs;
  var pastOrders = <OrderDetailedResponse>[].obs;

  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  fetchOrders() async {
    isLoading.value = true;
    try {
      log('Api working');
      ApiService().getOrders().then(
        (value) {
          orders.assignAll(value?.data??[]);
          currOrders.assignAll(orders
              .where(
                  (p0) => p0.status == 'PENDING' || p0.status == 'Food Packed')
              .toList());
          pastOrders.assignAll(orders
              .where((o) => o.status == 'COMPLETED' || o.status == 'CANCELLED')
              .toList());
        },
      );
    } catch (e) {
      log('Order Api error: $e');
      Get.snackbar('Error', 'Failed to fetch orders');
    } finally {
      isLoading.value = false;
    }
  }

  void reportIssue(String orderId, String issue) {
    // API Call to report issue
    Get.back(); // Close screen
    Get.snackbar('Success', 'Issue reported for Order #$orderId');
  }
}
