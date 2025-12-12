import 'dart:io';

import 'package:mobile_app/domain/repositories/i_user_repository.dart';

class SaveAvatarUseCase {
  final IUserRepository _repository;

  SaveAvatarUseCase(this._repository);

  Future<String> call({required String userId, required File imageFile}) {
    return _repository.saveAvatar(userId: userId, imageFile: imageFile);
  }
}
