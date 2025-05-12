import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../../utils/custom_toast.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
          await _auth.signOut();
          throw Exception("Please verify your email before logging in.");
        }

        final userDoc =
        await _firestore.collection('notesUsers').doc(user.uid).get();

        if (!userDoc.exists) {
          await createUserInDatabase(user, user.displayName ?? '');
        }
        return user;
      }

      return null;
    } catch (e) {
      debugPrint('Error in signInWithEmail: $e');
      throw Exception(e.toString());
    }
  }

  Future<void> createUserInDatabase(User user, String username) async {
    try {
      final data = UserModel(
        name: username,
        email: user.email ?? '',
        uid: user.uid,
      );

      await _firestore.collection('notesUsers').doc(user.uid).set(data.toMap());
      debugPrint('✅ User Inserted: ${user.uid}');
    } catch (e) {
      debugPrint('❌ Error creating user in DB: $e');
    }
  }

  Future<void> signOutUser() async {
    await _auth.signOut();
  }

  Future<User?> signUpWithEmail(
      String email, String password, String username) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        await user.sendEmailVerification();

        CustomToast.show(
          message: 'Please check your email for verification before logging in.',
        );
      }

      return user;
    } catch (e) {
      debugPrint("Error in signUpWithEmail: $e");
      throw Exception(e.toString());
    }
  }
}
