import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wallet_controller.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<WalletController>()) Get.put(WalletController());
    final controller = Get.find<WalletController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        automaticallyImplyLeading: false,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 50),
          children: [
            // Balance Card
            Card(
              color: Colors.teal,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text('Current Balance',
                        style: TextStyle(color: Colors.white70)),
                    Text('₹${controller.balance.value}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            const SizedBox(height: 16),
            _ActionButton(
                icon: Icons.add_card,
                label: 'Topup',
                onTap: () => Get.to(() => TopupView()),
                isFullWidth: true),
            const SizedBox(height: 16),
            _ActionButton(
                icon: Icons.history,
                label: 'Requests',
                onTap: () {
                  controller.getTopupRequests();

                  Get.to(() => TopupRequestsView());
                },
                isFullWidth: true),
          ],
        );
      }),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isFullWidth;

  const _ActionButton(
      {required this.icon,
      required this.label,
      required this.onTap,
      this.isFullWidth = false});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.teal,
        elevation: 1,
        padding: const EdgeInsets.symmetric(vertical: 24),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }
}

class TopupView extends StatelessWidget {
  const TopupView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();
    final amountController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Request Topup')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (amountController.text.isEmpty) {
                              Get.snackbar(
                                  "Error", "Please specify the amount");
                            } else {
                              showDialog(
                                context: Get.context!,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    title: Text('Request Topup'),
                                    content: Text(
                                        "Are you sure you want to topup for ₹${amountController.text}?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () => Get.back(),
                                          child: Text("Cancel")),
                                      TextButton(
                                        onPressed: () => controller
                                            .requestTopup(double.parse(
                                                amountController.text)),
                                        child: Obx(() =>
                                            (controller.isLoading.value)
                                                ? CircularProgressIndicator()
                                                : Text("Confirm")),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                    child: const Text('Proceed to Pay'),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentDialog(
      BuildContext context, WalletController controller, double amount) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Payment Gateway',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Processing Payment...',
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text('Amount: ₹$amount',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Simulate network/payment delay
    Future.delayed(const Duration(seconds: 3), () {
      Get.back(); // Close processing dialog
      controller.requestTopup(amount); // Proceed with request
    });
  }
}

class TopupRequestsView extends StatelessWidget {
  const TopupRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Topup Requests')),
      body: Obx(() => RefreshIndicator(
            onRefresh: () async => controller.getTopupRequests(),
            child: controller.isLoading.isTrue
                ? Center(child: CircularProgressIndicator())
                : controller.topupRequestsList.isEmpty
                    ? Center(child: Text("No requests available"))
                    : ListView.builder(
                        itemCount: controller.topupRequestsList.length,
                        itemBuilder: (context, index) {
                          final req = controller.topupRequestsList[index];
                          return ListTile(
                            title: Text('₹${req.amount}'),
                            subtitle: Text(req.createdAt.toString()),
                            trailing: Chip(
                              label: Text(req.status.toString()),
                              backgroundColor:
                                  req.status.toString() == 'PENDING'
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          );
                        },
                      ),
          )),
    );
  }
}

class TransactionsView extends StatelessWidget {
  const TransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WalletController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Obx(() => ListView.builder(
            itemCount: controller.transactions.length,
            itemBuilder: (context, index) {
              // final tx = controller.transactions[index];
              // final isCredit = tx['type'] == 'Credit';

              // return ListTile(
              //     leading: Icon(
              //       isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              //       color: isCredit ? Colors.green : Colors.red,
              //     ),
              //     title: Text(tx['desc']??''),
              //     subtitle: Text(tx['date']),
              //     trailing: Text(
              //       '${isCredit ? "+" : "-"} ₹${tx['amount']}',
              //       style: TextStyle(
              //         color: isCredit ? Colors.green : Colors.red,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   );
            },
          )),
    );
  }
}
