import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:online_notes/utils/validators.dart';
import '../../data/repositories/auth_repository.dart';
import '../../utils/custom_toast.dart';


class AuthController extends GetxController {
  final AuthRepository authRepository = AuthRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var isLogin = true.obs;
  var isLoading = false.obs;
  final loginFormKey = GlobalKey<FormState>();
  final signupFormKey = GlobalKey<FormState>();
  final context = Get.context;

  // Login Controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();

  // Signup Controllers
  final signupFullNameController = TextEditingController();
  final signupEmailController = TextEditingController();
  final signupPasswordController = TextEditingController();
  final signupConfirmPasswordController = TextEditingController();

  @override
  void onClose() {
    // Dispose controllers to prevent memory leaks
    loginEmailController.clear();
    loginPasswordController.clear();
   signupFullNameController.clear();
    signupEmailController.clear();
    signupPasswordController.clear();
    signupConfirmPasswordController.clear();
    super.onClose();
  }


  void changePassword(String newPassword, String currentPassword) async {
    isLoading.value = true;
    try {
      User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        // Re-authenticate the user before updating password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword, // User's current password
        );

        await user.reauthenticateWithCredential(credential);

        // If re-authentication is successful, update the password
        await user.updatePassword(newPassword);
        CustomToast.show(message: "Password updated successfully!");
        Get.back(); // Navigate back after success
      } else {
        CustomToast.show(
            message: "Error: User not found!", backgroundColor: Colors.red);
      }
    } catch (e) {
      CustomToast.show(
          message: "Error: ${e.toString()}", backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  void performEmailLogin(BuildContext context) async {
    if (loginFormKey.currentState!.validate()) {
      isLoading.value = true; // Show loading state
      try {
        final user = await authRepository.signInWithEmail(
          loginEmailController.value.text.trim(),
          loginPasswordController.value.text.trim(),
        );

        if (user != null) {
          await user
              .reload(); // Reload user data to get the latest email verification status
          if (!user.emailVerified) {
            CustomToast.show(
              message: 'Please verify your email before logging in.',
              backgroundColor: Colors.red,
            );
            return;
          }

          String userId = user.uid; // Get the logged-in user ID
          await fetchAndStoreUserProfile(userId); // Fetch & Save User Data

          CustomToast.show(message: 'Login Successful');
          context.go("/home");
        } else {
          CustomToast.show(
              message: 'Invalid email or password',
              backgroundColor: Colors.red);
        }
      } catch (e) {
        CustomToast.show(
            message: 'Error, ${e.toString()}', backgroundColor: Colors.red);
      } finally {
        isLoading.value = false; // Hide loading state
      }
    }
  }

  Future<void> fetchAndStoreUserProfile(String userId) async {
    try {

    } catch (e) {
      CustomToast.show(
          message: 'Error fetching user profile: $e',
          backgroundColor: Colors.red);
      debugPrint("Error fetching user profile: $e");
    }
  }

  void performEmailSignup(BuildContext context) async {
    if (!signupFormKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final user = await authRepository.signUpWithEmail(
        signupEmailController.text.trim(),
        signupPasswordController.text.trim(),
        signupFullNameController.text.trim(),
      );
      if (user != null) {
        CustomToast.show(
            message:
            'Please check your email for verification before logging in.');

        context.go(
          '/verification',
          extra: {
            'fullName': signupFullNameController.text.trim(),
          },
        );
      }
    } catch (e) {
      CustomToast.show(
          message: 'Error: ${e.toString()}', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }




  void performSignOut(BuildContext context) async {
    isLoading.value = true;
    try {
      await authRepository.signOutUser().then(
              (value) {
            CustomToast.show(message: 'Sign-out Successful');
            context.go("/login");
          });
    } catch (e) {
      CustomToast.show(
          message: 'Error, ${e.toString()}', backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> sendPasswordResetEmail() async {
    String email = loginEmailController.text.trim();

    if (email.isEmpty) {
      CustomToast.show(
          message: "Please enter your email address",
          backgroundColor: Colors.red);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      CustomToast.show(
          message: "If this email is registered, a reset link has been sent. \nDon't forgot to check your spambox",
          backgroundColor: Colors.green);
    } catch (e) {
      CustomToast.show(
          message: "Error: ${e.toString()}",
          backgroundColor: Colors.red);
    }
  }


  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email cannot be empty";
    }
    if (!Validators.emailRegexp.hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  String? validatePassword(String? value, {bool isSignup = false}) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (isSignup && value.length < 6) {
      return "Password too short";
    }
    // if (!AppConstants.strongPasswordRegexp.hasMatch(value)) {
    //   return "Password must contain at least one letter and one number";
    // }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password cannot be empty";
    }
    if (value != signupPasswordController.text) {
      return "Passwords do not match";
    }
    return null;
  }
}