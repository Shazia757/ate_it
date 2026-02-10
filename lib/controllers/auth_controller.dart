import 'package:ate_it/services/api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var isLoading = false.obs;

  // Login TextControllers
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register TextControllers
  final regNameController = TextEditingController();
  final regPhoneController = TextEditingController();
  final regEmailController = TextEditingController();
  final regStateController = TextEditingController();
  final regDistrictController = TextEditingController();
  final regCityController = TextEditingController();
  final regPincodeController = TextEditingController();
  final regPasswordController = TextEditingController();
  final regConfirmPasswordController = TextEditingController();

  // Forgot Password
  final forgotPhoneController = TextEditingController();

  @override
  onInit() {
    if (kDebugMode) {
      loginUsernameController.text = 'abc';
      loginPasswordController.text = 'abc';
    }

    super.onInit();
  }

  void login() async {
    if (loginUsernameController.text.isEmpty ||
        loginPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter username and password',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _apiService.login(
          loginUsernameController.text, loginPasswordController.text);
      isLoading.value = false;

      // Navigate to Home
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Login failed',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void register() async {
    // Basic validation
    if (regPasswordController.text != regConfirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      isLoading.value = true;
      await _apiService.register({
        'username': regNameController
            .text, // Assuming name is username for now based on docs
        'email': regEmailController.text,
        'password': regPasswordController.text,
        'role': 'CUSTOMER', // Defaulting to customer
        // 'phone': regPhoneController.text,
        // Add other fields as per API reqs if updated
      });
      isLoading.value = false;
      Get.snackbar('Success', 'Registration successful! Please login.',
          backgroundColor: Colors.green, colorText: Colors.white);
      Get.offNamed(Routes.LOGIN);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Registration failed',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void sendOtp() async {
    if (forgotPhoneController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter mobile number',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    await _apiService.sendOtp(forgotPhoneController.text);
    isLoading.value = false;

    Get.defaultDialog(
      title: "OTP Sent",
      middleText: "An OTP has been sent to your registered mobile number.",
      onConfirm: () {
        Get.back(); // close dialog
        Get.back(); // go back to login
      },
      textConfirm: "OK",
      confirmTextColor: Colors.white,
    );
  }

  @override
  void onClose() {
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    regNameController.dispose();
    // Dispose others...
    super.onClose();
  }
}
