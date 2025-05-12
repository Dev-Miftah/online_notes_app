import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateToNextScreen(context);
    });
  }

  void _navigateToNextScreen(BuildContext context) async {
    try {
      await Future.delayed(const Duration(seconds: 4));

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && !user.isAnonymous) {
        try {
          // Use a timeout to handle potential network issues
          await user.reload().timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              // If reload times out, proceed with current user state
              return;
            },
          );

          if (user.emailVerified) {
            context.go('/home');
          } else {
            context.go('/verification');
          }
        } catch (e) {
          // Network error or other issue during reload
          print('Error reloading user: $e');
          context.go('/login');
        }
      } else {
        context.go('/login');
      }
    } catch (e) {
      // General error handling
      print('Navigation error: $e');
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: const Icon(
                    Icons.note_add,
                    color: Colors.white,
                    size: 100.0,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const AnimatedOpacity(
              opacity: 1.0,
              duration: Duration(seconds: 2),
              child: Text(
                'Welcome to Notes App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}