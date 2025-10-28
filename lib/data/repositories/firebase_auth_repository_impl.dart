import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/data/datasources/firebase_data_source.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';

class FirebaseAuthRepositoryImpl implements IAuthRepository {
  final FirebaseDataSource _dataSource;

  FirebaseAuthRepositoryImpl(this._dataSource);

  @override
  Stream<User?> get userChanges {
    return _dataSource.userChanges;
  }

  @override
  User? get currentUser {
    return _dataSource.currentUser;
  }

  @override
  Future<User?> createUser({
    required String name,
    required String email,
    required String password,
  }) {
    return _dataSource.createUser(name, email, password);
  }

  @override
  Future<User?> signIn({required String email, required String password}) {
    return _dataSource.signIn(email, password);
  }

  @override
  Future<void> signOut() {
    return _dataSource.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    return _dataSource.sendPasswordResetEmail(email);
  }
}
