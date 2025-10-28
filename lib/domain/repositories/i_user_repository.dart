import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class IUserRepository {
  Stream<DocumentSnapshot> getUserStream(String uid);

  Future<void> createUserDocument({required User user, required String name});

  Future<void> updateUserBalance(String uid, double change);
}
