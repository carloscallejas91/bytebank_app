import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/services/database_service.dart';

class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseService _databaseService = Get.find();
  final Rxn<User> user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    _firebaseAuth.userChanges().listen((firebaseUser) {
      user.value = firebaseUser;
    });
  }

  User? get currentUser => user.value;

  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return userCredential.user;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint(
        "signInWithEmailAndPassword: um erro inesperado ocorreu durante o login: $e",
      );
      rethrow;
    }
  }

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

      final newUser = userCredential.user;
      if (newUser != null) {
        await newUser.updateDisplayName(name.trim());

        await _databaseService.createUserDocument(user: newUser, name: name.trim());

        await newUser.reload();
        return _firebaseAuth.currentUser;
      }
      return null;
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint(
        "createUserWithEmailAndPassword: um erro inesperado ocorreu: $e",
      );
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      debugPrint(
        "sendPasswordResetEmail: um erro inesperado ocorreu ao enviar o e-mail de recuperação: $e",
      );
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
