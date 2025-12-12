import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthRepository {
  Stream<User?> get userChanges;

  User? get currentUser;

  Future<User?> createUser({
    required String name,
    required String email,
    required String password,
  });

  Future<User?> signIn({required String email, required String password});

  Future<void> signOut();

  Future<void> sendPasswordResetEmail({required String email});
}
