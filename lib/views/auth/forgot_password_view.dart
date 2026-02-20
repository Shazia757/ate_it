import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('AteIt - Forgot Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter your registered mobile number to receive an OTP.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: c.forgotPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                prefixIcon: Icon(Icons.phone_android),
              ),
            ),
            const SizedBox(height: 24),
            Obx(() => ElevatedButton(
                  onPressed:
                      c.isLoading.value ? null : c.sendOtp,
                  child: c.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Send OTP'),
                )),
          ],
        ),
      ),
    );
  }
}
