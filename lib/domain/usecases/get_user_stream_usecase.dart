import 'package:mobile_app/domain/entities/account_entity.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';

class GetUserStreamUseCase {
  final IUserRepository _repository;

  GetUserStreamUseCase(this._repository);

  Stream<AccountEntity> call(String uid) {
    return _repository.getUserStream(uid);
  }
}
