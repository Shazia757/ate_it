import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../routes/app_routes.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;
  final PageController pageController = PageController();
  final GetStorage _storage = GetStorage();

  void updateIndex(int index) {
    pageIndex.value = index;
  }

  void completeOnboarding() {
    _storage.write('has_seen_onboarding', true);
    Get.offAllNamed(Routes.LOGIN);
  }
}
