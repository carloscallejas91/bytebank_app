import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<User?> createUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      if (userCredential.user != null) {
        await userCredential.user!.updateDisplayName(name.trim());
        await userCredential.user!.reload();

        return _firebaseAuth.currentUser;
      }
      return null;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint("createUserWithEmailAndPassword: um erro inesperado ocorreu: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      debugPrint("signOut: erro ao fazer logout: $e");
    }
  }
}