import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherHelper {
  static void launch(String url) async {
    // if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
    // }
  }
}
