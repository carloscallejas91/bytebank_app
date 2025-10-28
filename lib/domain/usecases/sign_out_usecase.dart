import 'package:mobile_app/domain/repositories/i_auth_repository.dart';

class SignOutUseCase {
  final IAuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<void> call() {
    return _repository.signOut();
  }
}
