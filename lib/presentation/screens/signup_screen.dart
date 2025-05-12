import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: authController.signupFormKey,
          child: Column(
            children: [
              TextFormField(
                controller: authController.signupFullNameController,
                decoration: InputDecoration(labelText: 'Full Name'),
              ),
              TextFormField(
                controller: authController.signupEmailController,
                validator: authController.validateEmail,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: authController.signupPasswordController,
                validator: (value) =>
                    authController.validatePassword(value, isSignup: true),
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                controller: authController.signupConfirmPasswordController,
                validator: authController.validateConfirmPassword,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Confirm Password'),
              ),
              Obx(() => authController.isLoading.value
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: authController.performEmailSignup,
                child: Text('Sign Up'),
              )),
            ],
          ),
        )
        ,
      ),
    );
  }
}
