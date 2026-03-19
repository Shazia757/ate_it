import 'dart:developer';

import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxList<RestaurantStatus> restaurantList = <RestaurantStatus>[].obs;
  var isLoading = true.obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    fetchRestaurants();
    super.onInit();
  }

  void fetchRestaurants()  {
    try {
      isLoading.value = true;
       ApiService().getRestaurants().then(
        (value) {
          restaurantList.assignAll(value?.data?.results ?? []);
          isLoading.value = false;
        },
      );
    } catch (e) {
      log(e.toString());
    }
  }

  List get filteredRestaurants {
  if (searchQuery.value.isEmpty) return restaurantList;

  return restaurantList.where((r) {
    return (r.restaurantName ?? '')
        .toLowerCase()
        .contains(searchQuery.value.toLowerCase());
  }).toList();
}
}
