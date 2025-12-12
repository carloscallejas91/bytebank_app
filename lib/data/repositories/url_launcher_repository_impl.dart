import 'package:mobile_app/domain/repositories/i_url_launcher_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncherRepositoryImpl implements IUrlLauncherRepository {
  @override
  Future<void> launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Não foi possível abrir o link: $url';
    }
  }
}
