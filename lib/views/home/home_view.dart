import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ate_it/views/cart/cart_view.dart';
import 'package:ate_it/controllers/cart_controller.dart';
import '../../controllers/home_controller.dart';
import '../../routes/app_routes.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<HomeController>()) {
      Get.put(HomeController());
    }
    // Ensure CartController is available and persists
    if (!Get.isRegistered<CartController>()) {
      Get.put(CartController());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('AteIt - Home'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const CartView()),
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.restaurantList.isEmpty) {
              return const Center(child: Text('No restaurants found.'));
            }

            return Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.restaurantList.length,
                itemBuilder: (context, index) {
                  final restaurant = controller.restaurantList[index];
                  final isOpen = restaurant.isOpen;

                  return Card(
                    color: isOpen ? Colors.white : Colors.grey.shade200,
                    elevation: isOpen ? 4 : 1,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor:
                            isOpen ? Colors.teal.shade50 : Colors.grey.shade300,
                        child: Icon(Icons.store,
                            color: isOpen ? Colors.teal : Colors.grey,
                            size: 28),
                      ),
                      title: Text(restaurant.restaurantName ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Expanded(
                                    child: Text(restaurant.address.toString(),
                                        overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            // Distance removed as not in API
                          ],
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                                color: isOpen ? Colors.green : Colors.red,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isOpen ? Colors.green : Colors.red)
                                        .withOpacity(0.4),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  )
                                ]),
                            child: Text(isOpen ? 'OPEN' : 'CLOSED',
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      onTap: isOpen
                          ? () {
                              // Navigate to Restaurant Details
                              Get.toNamed(Routes.RESTAURANT_DETAILS,
                                  arguments: restaurant);
                            }
                          : null,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                      .slideY(begin: 0.2);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
