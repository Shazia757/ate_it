import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();

  var balance = 0.0.obs;
  var transactions = <Map<String, dynamic>>[].obs;
  var topupRequests = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWalletData();
  }

  void fetchWalletData() async {
    try {
      isLoading.value = true;
      var data = await _apiService.getWalletData();
      balance.value = (data['balance'] as num).toDouble();
      transactions.value =
          List<Map<String, dynamic>>.from(data['transactions']);
      topupRequests.value =
          List<Map<String, dynamic>>.from(data['topupRequests']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallet data');
    } finally {
      isLoading.value = false;
    }
  }

  void requestTopup(double amount) {
    isLoading.value = true;
    // Simulate API call
    Future.delayed(const Duration(seconds: 1), () {
      topupRequests.add({
        'id': 'REQ${topupRequests.length + 1}',
        'amount': amount,
        'status': 'Pending',
        'date': DateTime.now().toString(),
      });
      // Auto approve for testing
      balance.value += amount;

      isLoading.value = false;
      Get.back();
      Get.snackbar('Success', 'Topup success for ₹$amount');
    });
  }

  bool deductBalance(double amount) {
    if (balance.value >= amount) {
      balance.value -= amount;
      transactions.add({
        "id": "TXN${DateTime.now().millisecondsSinceEpoch}",
        "amount": -amount,
        "type": "Debit",
        "date": DateTime.now().toString()
      });
      return true;
    }
    return false;
  }
}
