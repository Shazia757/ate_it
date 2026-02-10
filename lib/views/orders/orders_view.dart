import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/orders_controller.dart';
import '../../routes/app_routes.dart';

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
              _buildCurrentOrders(controller),
              _buildPastOrders(controller),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCurrentOrders(OrdersController controller) {
    if (controller.currentOrders.isEmpty) {
      return const Center(child: Text('No active orders'));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: controller.currentOrders.length,
      itemBuilder: (context, index) {
        final order = controller.currentOrders[index];
        // final items = order['items'] as List; // API doesn't return items in list

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order #${order.orderId}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(order.status,
                        style: const TextStyle(color: Colors.teal)),
                  ],
                ),
                const Divider(),
                Text(order.restaurantName ?? 'Unknown Restaurant',
                    style: const TextStyle(fontSize: 16)),
                // Text(order['location'], style: const TextStyle(color: Colors.grey)), // No location
                const SizedBox(height: 10),
                /*
                ...items.map((item) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item['type']} x${item['qty']}'),
                        Text('₹${item['price']}'),
                      ],
                    )),
                */
                const Text("Items details not available from list API"),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${order.totalAmount}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
              ],
            ),
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
        // final items = order['items'] as List;

        return Card(
          child: ListTile(
            title: Text(order.restaurantName ?? 'Unknown'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date: ${order.createdAt ?? "N/A"}'),
                // Text('Items: ${items.map((e) => e['name'] ?? e['type']).join(', ')}'),
                Text('Total: ₹${order.totalAmount}'),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.REPORT_ISSUE,
                  arguments: order.orderId), // Passing OrderID string
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              child: const Text('Report'),
            ),
          ),
        );
      },
    );
  }
}

class ReportIssueView extends StatelessWidget {
  const ReportIssueView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderId = Get.arguments as String;
    final textController = TextEditingController();
    final OrdersController controller = Get.find<OrdersController>();

    return Scaffold(
      appBar: AppBar(title: Text('Report Issue - #$orderId')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: textController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Describe your issue here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (textController.text.isNotEmpty) {
                  controller.reportIssue(orderId, textController.text);
                }
              },
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
