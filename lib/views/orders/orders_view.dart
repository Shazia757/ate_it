import 'dart:developer';

import 'package:ate_it/views/profile/issue_report_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/orders_controller.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final OrdersController controller = Get.put(OrdersController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Orders'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.fetchOrders(),
            )
          ],
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Current Orders'),
              Tab(text: 'Past Orders'),
            ],
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return TabBarView(
            children: [
              _currentOrders(controller),
              _buildPastOrders(controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _currentOrders(OrdersController controller) {
    if (controller.currOrders.isEmpty) {
      return const Center(child: Text('No active orders'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: controller.currOrders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = controller.currOrders[index];

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 STATUS DOT
              Container(
                margin: const EdgeInsets.only(top: 6),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  shape: BoxShape.circle,
                ),
              ),

              const SizedBox(width: 12),

              // 🔹 CONTENT
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏪 Restaurant + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order.restaurant?.restaurantName ??
                                'Unknown Restaurant',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          order.status ?? '',
                          style: const TextStyle(
                            color: Colors.teal,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // 📦 Order ID
                    Text(
                      "Order #${order.orderId}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // 💰 Total Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                        Text(
                          "₹${order.totalAmount}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPastOrders(OrdersController controller) {
    if (controller.pastOrders.isEmpty) {
      return const Center(child: Text('No past orders'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.pastOrders.length,
      itemBuilder: (context, index) {
        final order = controller.pastOrders[index];

        return Container(
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔴 Top Row (Restaurant + Status)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        order.restaurant?.restaurantName ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // 🟢 Status Badge (optional if you have status)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Completed",
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 10),

                // 📅 Date
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      DateTime.parse(order.createdAt.toString())
                          .toLocal()
                          .toString()
                          .split(' ')[0],
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // 💰 Total
                Row(
                  children: [
                    Icon(Icons.currency_rupee,
                        size: 16, color: Colors.grey.shade700),
                    Text(
                      '${order.totalAmount}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // 🔴 Divider
                Divider(color: Colors.grey.shade200),

                const SizedBox(height: 10),

                // 🔘 Bottom Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order ID: ${order.orderId}",
                      style:
                          TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.to(
                        () => IssueReportView(),
                        arguments: order.orderId,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      child: const Text(
                        'Report Issue',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

// class ReportIssueView extends StatelessWidget {
//   const ReportIssueView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // final orderId = Get.arguments as String;
//     final textController = TextEditingController();
//     final OrdersController controller = Get.find<OrdersController>();

//     return Scaffold(
//       appBar: AppBar(title: Text('Report Issue ')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: textController,
//               maxLines: 5,
//               decoration: const InputDecoration(
//                 hintText: 'Describe your issue here...',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 if (textController.text.isNotEmpty) {
//                   controller.reportIssue(orderId, textController.text);
//                 }
//               },
//               child: const Text('Submit Report'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
