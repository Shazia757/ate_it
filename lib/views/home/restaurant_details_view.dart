import 'package:ate_it/controllers/cart_controller.dart';
import 'package:ate_it/controllers/restaurant_controller.dart';
import 'package:ate_it/model/restaurant_model.dart';
import 'package:ate_it/views/cart/cart_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RestaurantDetailsView extends StatelessWidget {
  const RestaurantDetailsView({super.key, required this.restaurant});
  final RestaurantStatus restaurant;

  @override
  Widget build(BuildContext context) {
    final restaurant = Get.arguments as RestaurantStatus?;
    final RestaurantController c = Get.put(RestaurantController());

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant?.restaurantName ?? ''),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => c.fetchMenu(c.currentRestaurantId.value),
          )
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
            child: Obx(() => RefreshIndicator(
                  onRefresh: () async =>
                      c.fetchMenu(c.currentRestaurantId.value),
                  child: c.isLoading.isTrue
                      ? Center(child: CircularProgressIndicator())
                      : c.meals.isEmpty
                          ? Center(child: Text("No meals available"))
                          : ListView.builder(
                              itemCount: c.meals.length,
                              itemBuilder: (context, index) {
                                final meal = c.meals[index];
                                final isAvailable = meal.isAvailable;

                                return Card(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.fastfood,
                                      color: isAvailable
                                          ? Colors.green
                                          : Colors.grey,
                                      size: 24,
                                    ),
                                    title: Text(meal.name ?? ''),
                                    subtitle: Row(children: [
                                      Text(
                                        '₹${meal.price}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(width: 6),
                                      if (meal.originalPrice != null)
                                        Text(
                                          '₹${meal.originalPrice}',
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                    ]),
                                    trailing: isAvailable
                                        ? IconButton(
                                            icon: const Icon(
                                                Icons.add_shopping_cart,
                                                color: Colors.teal),
                                            onPressed: () => c.addToCart(meal),
                                          )
                                        : const Text('SOLD OUT',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                );
                              },
                            ),
                )),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final cartController = Get.find<CartController>();
        if (cartController.cartItems.isEmpty) return const SizedBox.shrink();

        return FloatingActionButton.extended(
          onPressed: () => Get.to(() => const CartView()),
          backgroundColor: Colors.teal,
          icon: const Icon(Icons.shopping_cart),
          label: Text(
              '${cartController.cartItems.length} Items - ₹${cartController.totalAmount}'),
        );
      }),
    );
  }
}
