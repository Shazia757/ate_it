import 'package:ate_it/model/restaurant_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/restaurant_controller.dart';

class RestaurantDetailsView extends StatelessWidget {
  const RestaurantDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get arguments passed from Home
    final restaurant = Get.arguments as Restaurant;
    final RestaurantController controller = Get.put(RestaurantController());

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.directions),
            tooltip: 'Get Directions',
            onPressed: () => controller.openMap(restaurant),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Available Meals',
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.meals.isEmpty) {
                return const Center(child: Text("No menu items available"));
              }
              return ListView.builder(
                itemCount: controller.meals.length,
                itemBuilder: (context, index) {
                  final meal = controller.meals[index];
                  // Assuming isAvailable means it's available. No Qty in API model?
                  // API Create Food Item has 'quantity', but Get Menu response example doesn't show it.
                  // Step 0: Get Restaurant Menu response: {id, name, price, original_price, is_available}
                  // No quantity. So we rely on isAvailable.

                  final isAvailable = meal.isAvailable;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.fastfood,
                        color: isAvailable ? Colors.green : Colors.grey,
                        size: 24,
                      ),
                      title: Text(meal.name),
                      subtitle: Text(
                          '₹${meal.price} ${meal.originalPrice != null ? "(${meal.originalPrice})" : ""}'),
                      trailing: isAvailable
                          ? IconButton(
                              icon: const Icon(Icons.add_shopping_cart,
                                  color: Colors.teal),
                              onPressed: () => controller.addToCart(meal),
                            )
                          : const Text('SOLD OUT',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold)),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
