import 'package:bytebank_app/domain/repositories/i_auth_repository.dart';

class SendPasswordResetEmailUseCase {
  final IAuthRepository _repository;

  SendPasswordResetEmailUseCase(this._repository);

  Future<void> call({required String email}) {
    return _repository.sendPasswordResetEmail(email: email);
  }
}
