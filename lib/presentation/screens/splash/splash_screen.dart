import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:online_notes/routes/app_pages.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 4));

    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.isAnonymous) {
      await user.reload();
      if (user.emailVerified) {
        Get.offAllNamed(AppPages.home);
      } else {
        Get.offAllNamed(AppPages.verification);
      }
    } else {
      Get.offAllNamed(AppPages.login);
    }
  }



  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Text('Welcome to Notes App'),
      ),
    );
  }
}