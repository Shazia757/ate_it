import 'dart:developer';

import 'package:ate_it/model/order_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiService _apiService = Get.find<ApiService>();

  var currentOrders = <OrderModel>[].obs;
  var pastOrders = <OrderModel>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  void fetchOrders() async {
    isLoading.value = true;
    try {
      final allOrders = await _apiService.getOrders();
      // Filter locally since API returns all
      currentOrders.assignAll(allOrders
          .where((o) => o.status == 'PENDING' || o.status == 'Food Packed')
          .toList());
      pastOrders.assignAll(allOrders
          .where((o) => o.status == 'COMPLETED' || o.status == 'CANCELLED')
          .toList());
    } catch (e) {
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
