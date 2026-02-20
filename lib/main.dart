import 'package:ate_it/views/auth/login_view.dart';
import 'package:ate_it/views/auth/onboarding_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/app_theme.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final bool hasSeenOnboarding = box.read('has_seen_onboarding') ?? false;

    return GetMaterialApp(
      title: 'AteIt',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: hasSeenOnboarding ? LoginView() : OnboardingView(),
      defaultTransition: Transition.cupertino,
    );
  }
}
