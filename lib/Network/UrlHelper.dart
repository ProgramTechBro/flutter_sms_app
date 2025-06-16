import 'ApiConfiguration.dart';

class UrlHelper {
  static String getBaseUrlFromEmail(String email) {
    final domain = email.split('@').last.toLowerCase();
    final subdomain = domain.split('.').first;
    return ApiConfig.baseUrlTemplate.replaceAll('{subdomain}', subdomain);
  }
}