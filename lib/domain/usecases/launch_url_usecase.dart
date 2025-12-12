import 'package:mobile_app/domain/repositories/i_url_launcher_repository.dart';

class LaunchUrlUseCase {
  final IUrlLauncherRepository _repository;

  LaunchUrlUseCase(this._repository);

  Future<void> call(String url) {
    return _repository.launch(url);
  }
}
