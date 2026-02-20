import 'package:ate_it/model/wallet_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  var balance = 0.0.obs;
  var transactions = <WalletModel>[].obs;
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
      await ApiService().getWalletData().then(
        (value) {
          // if (value?.status==true) {
          //   transactions.assignAll(value?.data);
          // }
        },
      );
      // balance.value = (data as num).toDouble();
      // transactions.value =
      //     List<Map<String, dynamic>>.from(data['transactions']);
      // topupRequests.value =
      //     List<Map<String, dynamic>>.from(data['topupRequests']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallet data');
    } finally {
      isLoading.value = false;
    }
  }

  void requestTopup(double amount) {
    isLoading.value = true;
    ApiService().sendTopupRequest({'amount': amount}).then(
      (value) {
        if (value?.status == true) {
          Get.snackbar('Success', 'Topup success for ₹$amount');
        } else {
          Get.snackbar('Error', 'Failed to update');
        }
        isLoading.value = false;
      },
    );
  }

  // bool deductBalance(double amount) {
  //   if (balance.value >= amount) {
  //     balance.value -= amount;
  //     transactions.add({
  //       "id": "TXN${DateTime.now().millisecondsSinceEpoch}",
  //       "amount": -amount,
  //       "type": "Debit",
  //       "date": DateTime.now().toString()
  //     });
  //     return true;
  //   }
  //   return false;
  // }
}
