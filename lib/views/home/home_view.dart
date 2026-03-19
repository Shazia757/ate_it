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
        title: const Text(
          "AteIt 🍽️",
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => c.fetchRestaurants(),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (c.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurants = c.filteredRestaurants;

        return Column(
          children: [
            // 🔴 HEADER + SEARCH
            Container(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Find leftover food near you",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 16),

                  // 🔍 SEARCH BAR
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        c.searchQuery.value = value;
                      },
                      decoration: const InputDecoration(
                        hintText: "Search restaurants...",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 🔴 LIST
            Expanded(
              child: restaurants.isEmpty
                  ? const Center(child: Text("No results found"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index];
                        final isOpen = restaurant.isOpen;

                        return GestureDetector(
                            onTap: isOpen
                                ? () {
                                    Get.to(
                                        () => RestaurantDetailsView(
                                              restaurant: restaurant,
                                            ),
                                        arguments: restaurant);
                                  }
                                : null,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔹 TOP BANNER
                                  Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                      gradient: LinearGradient(
                                        colors: isOpen
                                            ? [
                                                Colors.teal.shade300,
                                                Colors.teal.shade600
                                              ]
                                            : [
                                                Colors.grey.shade400,
                                                Colors.grey.shade600
                                              ],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        const Center(
                                          child: Icon(Icons.restaurant,
                                              size: 50, color: Colors.white),
                                        ),
                                        Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: isOpen
                                                  ? Colors.green
                                                  : Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              isOpen ? "OPEN" : "CLOSED",
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  // 🔹 DETAILS
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          restaurant.restaurantName ?? '',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(Icons.location_on,
                                                size: 16,
                                                color: Colors.grey.shade600),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                restaurant.address.toString(),
                                                style: TextStyle(
                                                    color:
                                                        Colors.grey.shade600),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              isOpen
                                                  ? "Available now"
                                                  : "Closed",
                                              style: TextStyle(
                                                color: isOpen
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                            Icon(Icons.arrow_forward_ios,
                                                size: 16,
                                                color: Colors.grey.shade500)
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                                .animate()
                                .fadeIn(
                                    duration: 400.ms, delay: (100 * index).ms)
                                .slideY(begin: 0.2));
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
