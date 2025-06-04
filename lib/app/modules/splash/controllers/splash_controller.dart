import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../routes/app_pages.dart';
class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = await isUserLoggedIn();
    if (loggedIn) {
      Get.offNamed(Routes.HOME);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}

Future<bool> isUserLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('is_user_logged_in') ?? false;
  final accessToken = prefs.getString('access_token');
  final tokenExpiry = prefs.getString('token_expiry');

  if (!isLoggedIn || accessToken == null || accessToken.isEmpty || tokenExpiry == null) {
    return false;
  }

  final expiryTime = DateTime.tryParse(tokenExpiry);
  if (expiryTime == null || DateTime.now().isAfter(expiryTime)) {
    await prefs.remove('access_token');
    await prefs.remove('token_expiry');
    await prefs.setBool('is_user_logged_in', false);
    return false;
  }
  return true;
}

