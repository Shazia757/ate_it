import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'services/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

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
      initialRoute: hasSeenOnboarding ? AppPages.INITIAL : Routes.ONBOARDING,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
