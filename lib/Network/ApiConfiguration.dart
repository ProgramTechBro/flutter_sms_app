class ApiConfig {
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const String contentType = 'application/json';
  static const String baseUrlTemplate = 'https://{subdomain}.codecrushtech.com/api/';
}