import 'package:ate_it/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController controller = Get.put(CartController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const Center(
            child: Text(
              'Your cart is empty',
              style: TextStyle(fontSize: 18),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Icon(Icons.store, color: Colors.teal),
                  const SizedBox(width: 8),
                  Text(controller.restaurantName.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems.keys.elementAt(index);
                  final quantity = controller.cartItems[item];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(item.name ?? ''),
                      subtitle: Text('₹${item.price}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => controller.removeFromCart(item),
                          ),
                          Text('$quantity',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => controller.addToCart(
                                item,
                                controller.restaurantId.value,
                                controller.restaurantName.value),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('₹${controller.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => controller.checkout(),
                      child: const Text('Pay & Order',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
