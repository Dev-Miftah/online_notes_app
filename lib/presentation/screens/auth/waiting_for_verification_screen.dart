import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../utils/custom_toast.dart';
import '../../controllers/auth_controller.dart';

class WaitingForVerificationScreen extends StatefulWidget {
  final String fullName;
  const WaitingForVerificationScreen({Key? key, required this.fullName}) : super(key: key);

  @override
  State<WaitingForVerificationScreen> createState() =>
      _WaitingForVerificationScreenState();
}

class _WaitingForVerificationScreenState
    extends State<WaitingForVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthRepository _authRepository = AuthRepository();
 // final AuthController authController = Get.put(AuthController());
  final authController = Get.find<AuthController>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startVerificationCheck();
  }

  void _startVerificationCheck() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _auth.currentUser?.reload(); // Refresh user data
      final user = _auth.currentUser;

      if (user != null && user.emailVerified) {
        await _authRepository.createUserInDatabase(user, widget.fullName);
        print("User Name: ${widget.fullName}");
        _timer?.cancel();
        context.go('/home');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.email, size: 100, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    'Verify Your Email',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Please verify your email to continue.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _checkVerificationManually,
                    child: const Text("Check Verification"),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _checkVerificationManually() async {
    await _auth.currentUser?.reload();
    final user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      await _authRepository.createUserInDatabase(
          user, authController.signupFullNameController.text);
      _timer?.cancel();
      context.go('/home');
    } else {
      CustomToast.show(
        message: 'Email not verified yet. Please check your inbox.',
        backgroundColor: Colors.red,
      );
    }
  }
}
