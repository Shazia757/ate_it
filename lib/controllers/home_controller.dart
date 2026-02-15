import 'dart:developer';

import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  RxList<RestaurantStatus> restaurantList = <RestaurantStatus>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchRestaurants();
    super.onInit();
  }

  void fetchRestaurants()  {
    try {
      isLoading.value = true;
       _apiService.getRestaurants().then(
        (value) {
          restaurantList.assignAll(value?.data?.results ?? []);
          isLoading.value = false;
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }
}
