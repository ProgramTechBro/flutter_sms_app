import 'package:dio/dio.dart';
class DioService {
  static final DioService _instance = DioService._internal();
  late Dio dio;

  factory DioService() {
    return _instance;
  }

  DioService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://sms.codecrushtech.com/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        contentType: 'application/json',
      ),
    );
  }
}
