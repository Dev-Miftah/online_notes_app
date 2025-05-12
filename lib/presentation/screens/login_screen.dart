import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_pages.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: authController.loginFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: authController.loginEmailController,
                validator: authController.validateEmail,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: authController.loginPasswordController,
                validator: (value) => authController.validatePassword(value),
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: authController.performEmailLogin,
                child: Text('Login'),
              )),
              TextButton(onPressed: () => Get.toNamed(AppPages.register), child: const Text("Don't have an account? Sign up"))
            ],
          ),
        ),
      ),
    );
  }
}
