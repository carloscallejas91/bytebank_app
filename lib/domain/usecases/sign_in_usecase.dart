import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_app/domain/repositories/i_auth_repository.dart';

class SignInUseCase {
  final IAuthRepository _repository;

  SignInUseCase(this._repository);

  Future<User?> call({required String email, required String password}) {
    return _repository.signIn(email: email, password: password);
  }
}
