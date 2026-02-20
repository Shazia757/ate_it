import 'package:ate_it/model/user_model.dart';
import 'package:ate_it/services/api.dart';
import 'package:ate_it/services/local_storage.dart';
import 'package:ate_it/views/auth/login_view.dart';
import 'package:ate_it/views/main_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {

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

    await ApiService()
        .login(loginUsernameController.text, loginPasswordController.text)
        .then(
      (response) async {
        if (response?.status == true) {
          await LocalStorage().writeUser(response?.data ?? User());
          await LocalStorage().writePassword(loginPasswordController.text);

          Get.snackbar('Login success', 'Welcome ${response?.data?.username}');
          Get.offAll(MainView());
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

    ApiService().register({
      'username': regUserNameController.text,
      'first_name': regUserNameController.text,
      'last_name': regUserNameController.text,
      'email': regEmailController.text,
      'password': regPasswordController.text,
      'role': 'CUSTOMER',
      'phone_number': regPhoneController.text,
      'confirm_pass': regConfirmPasswordController.text
    }).then(
      (response) async {
        if (response?.status == true) {
          await LocalStorage().writeUser(response?.data ?? User());
          Get.offAll(LoginView());
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
    await ApiService().sendOtp(forgotPhoneController.text);
    isLoading.value = false;

    Get.defaultDialog(
      title: "OTP Sent",
      middleText: "An OTP has been sent to your registered mobile number.",
      onConfirm: () {
        Get.back();
        Get.back();
      },
      textConfirm: "OK",
      confirmTextColor: Colors.white,
    );
  }
}
