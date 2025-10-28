import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_app/domain/repositories/i_user_repository.dart';

class GetUserStreamUseCase {
  final IUserRepository _repository;

  GetUserStreamUseCase(this._repository);

  Stream<DocumentSnapshot> call(String uid) {
    return _repository.getUserStream(uid);
  }
}
