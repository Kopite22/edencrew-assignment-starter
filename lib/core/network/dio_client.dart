import 'package:dio/dio.dart';

class DioClient {
  DioClient._();

  static final DioClient instance = DioClient._();

  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ),
  );
}
