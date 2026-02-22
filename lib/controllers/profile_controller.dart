import 'package:ate_it/services/api.dart';
import 'package:ate_it/services/local_storage.dart';
import 'package:ate_it/views/auth/login_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  var isEditing = false.obs;
  var isLoading = false.obs;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController usernameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  // late TextEditingController stateController;
  // late TextEditingController districtController;
  // late TextEditingController cityController;
  // late TextEditingController pincodeController;

  @override
  void onInit() {
    super.onInit();
    firstNameController =
        TextEditingController(text: LocalStorage().readUser().firstName);
    lastNameController =
        TextEditingController(text: LocalStorage().readUser().lastName);
    usernameController =
        TextEditingController(text: LocalStorage().readUser().username);
    phoneController = TextEditingController(
        text: LocalStorage().readUser().phoneNumber.toString());
    emailController =
        TextEditingController(text: LocalStorage().readUser().email);
    // stateController =
    //     TextEditingController(text: LocalStorage().readUser().state);
    // districtController =
    //     TextEditingController(text: LocalStorage().readUser().district);
    // cityController =
    //     TextEditingController(text: LocalStorage().readUser().city);
    // pincodeController =
    //     TextEditingController(text: LocalStorage().readUser().pincode);
  }

  void logout() {
    isLoading.value = true;
    ApiService().logout().then(
      (value) {
        isLoading.value = false;
        if (value?.status ?? false) {
          LocalStorage().clearAll();
          Get.offAll(() => LoginView());
        }
      },
    );
  }

  void toggleEdit() async {
    if (isEditing.value) {
      await ApiService().updateProfile({
        'username': usernameController.text,
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'phone_number': phoneController.text,
        // 'state': stateController.text,
        // 'district': districtController.text,
        // 'city': cityController.text,
        // 'pincode': pincodeController.text
      }).then(
        (value) {
          if (value?.status == true) {
            Get.snackbar('Success', 'Profile updated');
          } else {
            Get.snackbar('Error', 'Failed to update');
          }
        },
      );
      // Save changes logic

      Get.snackbar('Success', 'Profile Updated');
    }
    isEditing.toggle();
  }
}
