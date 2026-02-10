import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var restaurants = <Restaurant>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRestaurants();
  }

  void fetchRestaurants() async {
    try {
      isLoading.value = true;
      var data = await _apiService.getRestaurants();
      // Sort by distance ?? API doesn't return distance, only address details
      // If we need distance, we need to calculate it or mock it.
      // For now, just listing.
      restaurants.assignAll(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load restaurants');
    } finally {
      isLoading.value = false;
    }
  }
}
