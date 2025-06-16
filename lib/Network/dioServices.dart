// import 'package:dio/dio.dart';
// class DioService {
//   static final DioService _instance = DioService._internal();
//   late Dio dio;
//
//   factory DioService() {
//     return _instance;
//   }
//
//   DioService._internal() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://sms.codecrushtech.com/api/',
//         connectTimeout: const Duration(seconds: 10),
//         receiveTimeout: const Duration(seconds: 30),
//         contentType: 'application/json',
//       ),
//     );
//   }
// }
import 'package:dio/dio.dart';
import 'ApiConfiguration.dart';

class DioService {
  static DioService? _instance;
  late Dio _dio;
  String? _currentBaseUrl;

  DioService._internal();

  static DioService get instance {
    _instance ??= DioService._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void initialize(String baseUrl) {
    if (_currentBaseUrl == baseUrl) return;

    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: ApiConfig.contentType,
    ));

    _currentBaseUrl = baseUrl;
  }
}