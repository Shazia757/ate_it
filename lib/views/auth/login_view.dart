import 'package:ate_it/views/auth/forgot_password_view.dart';
import 'package:ate_it/views/auth/register_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../controllers/auth_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController c = Get.put(AuthController());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(Icons.restaurant_menu,
                          size: 80, color: Theme.of(context).primaryColor)
                      .animate()
                      .scale(duration: 600.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 16),
                  Text(
                    'AteIt',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                  ).animate().fadeIn().slideY(begin: 0.3, duration: 500.ms),
                  const SizedBox(height: 40),

                  TextField(
                    controller: c.loginUsernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.2),
                  const SizedBox(height: 16),
                  TextField(
                    controller: c.loginPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.2),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Get.to(()=>ForgotPasswordView()),
                      child: const Text('Forgot Password?'),
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                  const SizedBox(height: 24),

                  // Login Button
                  Obx(() => ElevatedButton(
                        onPressed: c.login,
                        child: c.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Login'),
                      )).animate().fadeIn(delay: 500.ms).scale(),

                  const SizedBox(height: 16),

                  // Register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () => Get.to(()=>RegisterView()),
                        child: const Text('Create Account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
