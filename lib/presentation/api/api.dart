import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  final Dio _dio = Dio();

  API() {
    DotEnv().load(fileName: ".env");
    _dio.options.baseUrl = DotEnv().env['api_url']!;
    _dio.options.headers = {
      'Content-Type': 'application/json',
    };

    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers['Authorization'] = 'Bearer ${DotEnv().env['token']}';
      return handler.next(options);
    }));
  }
  Dio get dio => _dio;
}
