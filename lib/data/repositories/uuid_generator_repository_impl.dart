import 'package:mobile_app/domain/repositories/i_id_generator_repository.dart';
import 'package:uuid/uuid.dart';

class UuidGeneratorRepositoryImpl implements IIdGeneratorRepository {
  final Uuid _uuid;

  UuidGeneratorRepositoryImpl({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  @override
  String generate() {
    return _uuid.v4();
  }
}
