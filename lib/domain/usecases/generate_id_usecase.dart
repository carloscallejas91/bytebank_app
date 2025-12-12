import 'package:mobile_app/domain/repositories/i_id_generator_repository.dart';

class GenerateIdUseCase {
  final IIdGeneratorRepository _repository;

  GenerateIdUseCase(this._repository);

  String call() {
    return _repository.generate();
  }
}
