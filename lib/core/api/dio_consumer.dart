import 'package:dio/dio.dart';
import 'package:general_app/core/errors/exceptions.dart';
import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio});

  @override
  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> post(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final requestHeaders = headers != null ? Map<String, String>.from(headers) : <String, String>{};
      if (body is FormData) {
        requestHeaders.remove('Content-Type');
        requestHeaders.remove('content-type');
      }
      final response = await dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: requestHeaders.isEmpty ? null : requestHeaders,
          contentType: body is FormData ? null : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> put(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final requestHeaders = headers != null ? Map<String, String>.from(headers) : <String, String>{};
      if (body is FormData) {
        requestHeaders.remove('Content-Type');
        requestHeaders.remove('content-type');
      }
      final response = await dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: requestHeaders.isEmpty ? null : requestHeaders,
          contentType: body is FormData ? null : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final response = await dio.delete(
        path,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<dynamic> patch(
    String path, {
    dynamic body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final requestHeaders = headers != null ? Map<String, String>.from(headers) : <String, String>{};
      if (body is FormData) {
        requestHeaders.remove('Content-Type');
        requestHeaders.remove('content-type');
      }
      final response = await dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
        options: Options(
          headers: requestHeaders.isEmpty ? null : requestHeaders,
          contentType: body is FormData ? null : 'application/json',
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException error) {
    if (error.response?.statusCode == 302) {
      final location = error.response?.headers.value('location');
      return ServerException(
        message: 'Server redirect error. Please check API URL. Redirecting to: $location',
        statusCode: 302,
      );
    }
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(message: 'Connection timed out. Please try again.');
        
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data?['message'] ?? 'An unexpected error occurred';
        
        if (statusCode == 401) return UnauthorizedException(message: message);
        if (statusCode == 403) return ForbiddenException(message: message);
        if (statusCode == 404) return NotFoundException(message: message);
        if (statusCode == 422) return ValidationException(message: message, errors: error.response?.data?['errors']);
        
        return ServerException(message: message, statusCode: statusCode);
        
      case DioExceptionType.cancel:
        return ServerException(message: 'Request was cancelled');
        
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection. Please check your network.');
        
      default:
        return ServerException(message: 'Unknown error occurred. Please try again later.');
    }
  }
}
