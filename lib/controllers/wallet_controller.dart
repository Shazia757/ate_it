import 'dart:developer';

import 'package:ate_it/model/wallet_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:get/get.dart';

class WalletController extends GetxController {
  var balance = "0.00".obs;
  var transactions = <WalletModel>[].obs;
  var topupRequestsList = <TopupModel>[].obs;
  var isLoading = false.obs;

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
          if (value?.status == true) {
            balance.value = value?.data?.balance ?? "";
            log(balance.value);
          }
          isLoading.value = false;
        },
      );
      // balance.value = (data as num).toDouble();
      
      // topupRequests.value =
      //     List<Map<String, dynamic>>.from(data['topupRequests']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load wallet data');
    }
  }

  void getTopupRequests() async {
    isLoading.value = true;
    await ApiService().getTopupRequests().then(
      (value) {
        log(value?.status.toString() ?? '');

        if (value?.status == true) {
          topupRequestsList.assignAll((value?.data ?? []));

        }
        isLoading.value = false;
      },
    );
  }

  void requestTopup(double amount) {
    isLoading.value = true;
    ApiService().sendTopupRequest({'amount': amount}).then(
      (value) {
        if (value?.status == true) {
          Get.back();
          Get.snackbar('Success', 'Topup success for ₹$amount');
        } else {
          Get.snackbar('Error', 'Failed to update');
        }
        log(value!.status.toString());
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
