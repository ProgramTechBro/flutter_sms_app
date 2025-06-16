import 'package:shared_preferences/shared_preferences.dart';
import '../../Network/dioServices.dart';

class AppInitializer {
  static Future<void> initializeDioFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final baseUrl = prefs.getString('base_url');

    if (baseUrl != null && Uri.tryParse(baseUrl)?.isAbsolute == true) {
      DioService.instance.initialize(baseUrl);
    }
  }
}
