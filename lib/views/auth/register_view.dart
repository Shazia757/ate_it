import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('AteIt - Register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: c.regFirstNameController,
                decoration: const InputDecoration(
                    labelText: 'First Name', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: c.regLastNameController,
                decoration: const InputDecoration(
                    labelText: 'Last Name', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: c.regPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: c.regEmailController,
                validator: (value) {
                  final RegExp emailPattern = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

                  if (!emailPattern.hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: c.regStateController,
                      decoration: const InputDecoration(labelText: 'State'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: c.regDistrictController,
                      decoration: const InputDecoration(labelText: 'District'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: c.regCityController,
                      decoration: const InputDecoration(labelText: 'City'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: c.regPincodeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Pincode'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: c.regUserNameController,
                decoration: const InputDecoration(
                    labelText: 'Username', prefixIcon: Icon(Icons.person)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: c.regPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', prefixIcon: Icon(Icons.lock)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: c.regConfirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outline)),
              ),
              const SizedBox(height: 32),
              Obx(() => ElevatedButton(
                    onPressed: c.register,
                    child: c.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Register'),
                  )),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Back to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
