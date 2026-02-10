import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  // Simulating user data
  var user = {
    'name': 'John Doe',
    'phone': '9876543210',
    'email': 'john@example.com',
    'state': 'Kerala',
    'district': 'Ernakulam',
    'city': 'Kochi',
    'pincode': '682001',
  }.obs;

  var isEditing = false.obs;

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController stateController;
  late TextEditingController districtController;
  late TextEditingController cityController;
  late TextEditingController pincodeController;

  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController(text: user['name']);
    phoneController = TextEditingController(text: user['phone']);
    emailController = TextEditingController(text: user['email']);
    stateController = TextEditingController(text: user['state']);
    districtController = TextEditingController(text: user['district']);
    cityController = TextEditingController(text: user['city']);
    pincodeController = TextEditingController(text: user['pincode']);
  }

  void toggleEdit() {
    if (isEditing.value) {
      // Save changes logic
      user['name'] = nameController.text;
      user['phone'] = phoneController.text;
      user['email'] = emailController.text;
      user['state'] = stateController.text;
      user['district'] = districtController.text;
      user['city'] = cityController.text;
      user['pincode'] = pincodeController.text;

      Get.snackbar('Success', 'Profile Updated');
    }
    isEditing.toggle();
  }
}
