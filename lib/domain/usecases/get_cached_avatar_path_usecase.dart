import 'package:mobile_app/domain/repositories/i_user_repository.dart';

class GetCachedAvatarPathUseCase {
  final IUserRepository _repository;

  GetCachedAvatarPathUseCase(this._repository);

  Future<String?> call({required String userId}) {
    return _repository.getCachedAvatarPath(userId: userId);
  }
}
