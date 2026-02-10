import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var meals = <FoodItem>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // In a real app, we'd pass the ID and fetch.
    // For now assuming we are on details page and arguments are passed or handled in UI.
    // But this controller is put() in the view.
    // We need to know WHICH restaurant to fetch for.
    // The view passes arguments. We can get arguments here or call a method.
    if (Get.arguments != null && Get.arguments is Restaurant) {
      final restaurant = Get.arguments as Restaurant;
      fetchMenu(restaurant.id);
    }
  }

  void fetchMenu(int restaurantId) async {
    try {
      isLoading.value = true;
      meals.value = await _apiService.getRestaurantMenu(restaurantId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu');
    } finally {
      isLoading.value = false;
    }
  }

  void addToCart(FoodItem meal) {
    // Add logic to add to cart (using another controller or service)
    Get.snackbar('Added', '${meal.name} added to cart',
        duration: const Duration(seconds: 1));
  }

  Future<void> openMap(Restaurant restaurant) async {
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
