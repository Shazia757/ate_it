import 'package:ate_it/views/home/restaurant_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController c = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AteIt - Home'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() => (c.isLoading.value)
          ? Center(child: CircularProgressIndicator())
          : (c.restaurantList.isEmpty)
              ? Center(child: Text('No restaurants found'))
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: c.restaurantList.length,
                    itemBuilder: (context, index) {
                      final restaurant = c.restaurantList[index];
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
                            backgroundColor: isOpen
                                ? Colors.teal.shade50
                                : Colors.grey.shade300,
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
                                        child: Text(
                                            restaurant.address.toString(),
                                            overflow: TextOverflow.ellipsis)),
                                  ],
                                ),
                                const SizedBox(height: 4),
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
                                        color:
                                            (isOpen ? Colors.green : Colors.red)
                                                .withValues(alpha: 0.4),
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
                                  Get.to(() => RestaurantDetailsView(),
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
                )),
    );
  }
}
