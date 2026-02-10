import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/wallet_controller.dart';
import '../../routes/app_routes.dart';

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
          padding: const EdgeInsets.all(16),
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
            Row(
              children: [
                Expanded(
                    child: _ActionButton(
                        icon: Icons.add_card,
                        label: 'Topup',
                        onTap: () => Get.toNamed(Routes.WALLET_TOPUP))),
                const SizedBox(width: 16),
                Expanded(
                    child: _ActionButton(
                        icon: Icons.history,
                        label: 'Requests',
                        onTap: () =>
                            Get.toNamed(Routes.WALLET_TOPUP_REQUESTS))),
              ],
            ),
            const SizedBox(height: 16),
            _ActionButton(
                icon: Icons.list_alt,
                label: 'View Transactions',
                onTap: () => Get.toNamed(Routes.WALLET_TRANSACTIONS),
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
                            if (amountController.text.isNotEmpty) {
                              _showDummyPaymentDialog(context, controller,
                                  double.parse(amountController.text));
                            }
                          },
                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Proceed to Pay'),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _showDummyPaymentDialog(
      BuildContext context, WalletController controller, double amount) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Payment Gateway (Mock)',
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
      body: Obx(() => ListView.builder(
            itemCount: controller.topupRequests.length,
            itemBuilder: (context, index) {
              final req = controller.topupRequests[index];
              return ListTile(
                title: Text('₹${req['amount']}'),
                subtitle: Text(req['date']),
                trailing: Chip(
                  label: Text(req['status']),
                  backgroundColor:
                      req['status'] == 'Pending' ? Colors.orange : Colors.green,
                ),
              );
            },
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
              final tx = controller.transactions[index];
              final isCredit = tx['type'] == 'Credit';

              return ListTile(
                leading: Icon(
                  isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isCredit ? Colors.green : Colors.red,
                ),
                title: Text(tx['desc']),
                subtitle: Text(tx['date']),
                trailing: Text(
                  '${isCredit ? "+" : "-"} ₹${tx['amount']}',
                  style: TextStyle(
                    color: isCredit ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          )),
    );
  }
}
