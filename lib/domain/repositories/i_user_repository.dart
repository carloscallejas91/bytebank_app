import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/domain/entities/account_entity.dart';

abstract class IUserRepository {
  Stream<AccountEntity> getUserStream(String uid);
  Future<void> createUserDocument({required User user, required String name});
  Future<void> updateUserBalance(String uid, double change);
  Future<String> saveAvatar({required String userId, required File imageFile});
  Future<String?> getCachedAvatarPath({required String userId});
}
