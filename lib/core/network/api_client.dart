import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'api_exceptions.dart';

class ApiClient {
  late final Dio _dio;
  final Dio _downloadDio = Dio();

  ApiClient({String? apiKey}) {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.openAiBaseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 120),
      headers: {
        'Content-Type': 'application/json',
        if (apiKey != null && apiKey.isNotEmpty)
          'Authorization': 'Bearer $apiKey',
      },
    ));
  }

  void updateApiKey(String apiKey) {
    _dio.options.headers['Authorization'] = 'Bearer $apiKey';
  }

  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Response> postMultipart(String path, {required FormData formData}) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        options: Options(contentType: 'multipart/form-data'),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> downloadFile(String url, String savePath) async {
    try {
      await _downloadDio.download(url, savePath);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 401) return const AuthException();
        if (statusCode == 429) return const RateLimitException();
        if (statusCode == 500) return const ServerException();
        return ApiException('Request failed ($statusCode).', statusCode);
      case DioExceptionType.connectionError:
        return const NetworkException();
      default:
        return const ApiException('Something went wrong. Please try again.');
    }
  }
}
