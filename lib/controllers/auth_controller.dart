import 'package:ate_it/model/user_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:ate_it/services/local_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final ApiService _apiService = Get.put(ApiService());

  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Login TextControllers
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Register TextControllers
  final regFirstNameController = TextEditingController();
  final regLastNameController = TextEditingController();
  final regUserNameController = TextEditingController();
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
      loginUsernameController.text = 'test';
      loginPasswordController.text = 'test123';
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
    isLoading.value = true;

    await _apiService
        .login(loginUsernameController.text, loginPasswordController.text)
        .then(
      (response) async {
        if (response?.status == true) {
          await LocalStorage().writeUser(response?.data ?? User());
          await LocalStorage().writePassword(loginPasswordController.text);

          Get.snackbar('Login success', 'Welcome ${response?.data?.username}');
          Get.offAllNamed(Routes.MAIN);
        } else {
          errorMessage.value = 'Failed to login!';
          Get.snackbar('Error', 'Failed to login!');
        }
        isLoading.value = false;
      },
    );
  }

  Future<void> register() async {
    if (regFirstNameController.text.isEmpty ||
        regLastNameController.text.isEmpty ||
        regUserNameController.text.isEmpty ||
        regPhoneController.text.isEmpty ||
        regEmailController.text.isEmpty ||
        regStateController.text.isEmpty ||
        regDistrictController.text.isEmpty ||
        regCityController.text.isEmpty ||
        regPincodeController.text.isEmpty ||
        regPasswordController.text.isEmpty ||
        regConfirmPasswordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill out all fields!');
      return;
    }

    // Basic validation
    if (regPasswordController.text != regConfirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    final RegExp emailPattern =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailPattern.hasMatch(regEmailController.text)) {
      Get.snackbar('Error', 'Please enter a valid email address',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }
    isLoading.value = true;

    _apiService.register({
      'username': regUserNameController.text,
      'first_name': regUserNameController.text,
      'last_name': regUserNameController.text,
      'email': regEmailController.text,
      'password': regPasswordController.text,
      'role': 'CUSTOMER',
      'phone_number': regPhoneController.text,
      'state': regStateController.text,
      'district': regDistrictController.text,
      'city': regCityController.text,
      'pincode': regPincodeController.text,
      'confirm_pass': regConfirmPasswordController.text
    }).then(
      (response) async {
        if (response?.status == true) {
          await LocalStorage().writeUser(response?.data ?? User());
          Get.offAllNamed(Routes.LOGIN);
        } else {
          errorMessage.value = 'Failed to register!';
          Get.snackbar('Error', 'Failed to register!');
        }
        isLoading.value = false;
      },
    );
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
    // loginUsernameController.dispose();
    // loginPasswordController.dispose();
    // regFirstNameController.dispose();
    // regLastNameController.dispose();
    // regUserNameController.dispose();
    // regEmailController.dispose();
    // regStateController.dispose();
    // regDistrictController.dispose();
    // regCityController.dispose();
    // regPincodeController.dispose();
    // regPasswordController.dispose();
    // regConfirmPasswordController.dispose();

    super.onClose();
  }
}
