import 'package:firebase_auth/firebase_auth.dart';
import 'package:bytebank_app/domain/repositories/i_auth_repository.dart';

class CreateUserUseCase {
  final IAuthRepository _authRepository;

  CreateUserUseCase(this._authRepository);

  Future<User?> call({
    required String name,
    required String email,
    required String password,
  }) {
    return _authRepository.createUser(
      name: name,
      email: email,
      password: password,
    );
  }
}
