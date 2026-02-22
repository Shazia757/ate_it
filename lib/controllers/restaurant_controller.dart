import 'package:ate_it/controllers/cart_controller.dart';
import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantController extends GetxController {
  final CartController c = Get.put(CartController());

  var meals = <FoodItem>[].obs;
  var isLoading = true.obs;
  var currentRestaurantId = (-1).obs;
  var currentRestaurantName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is RestaurantStatus) {
      final restaurant = Get.arguments as RestaurantStatus;
      currentRestaurantName.value = restaurant.restaurantName ?? '';
      fetchMenu(restaurant.id ?? 0);
    }
  }

  void fetchMenu(int restaurantId) {
    currentRestaurantId.value = restaurantId;
    try {
      isLoading.value = true;

      ApiService().getRestaurantMenu(restaurantId).then(
        (value) {
          meals.assignAll(value?.data ?? []);
          isLoading.value = false;
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu');
    }
  }

  void addToCart(FoodItem meal) {
    c.addToCart(meal, currentRestaurantId.value, currentRestaurantName.value);
  }

  Future<void> openMap(RestaurantStatus restaurant) async {
    // Mock coordinates
    final double lat = 12.9716;
    final double lng = 77.5946;
    final Uri googleMapsUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      Get.snackbar('Error', 'Could not open maps');
    }
  }
}
