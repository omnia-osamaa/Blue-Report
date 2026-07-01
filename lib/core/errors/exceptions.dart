
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException({
    required this.message,
    this.statusCode,
  });

  @override
  String toString() => message;
}



class ServerException extends AppException {
  ServerException({
    required super.message,
    super.statusCode,
  });
}



class CacheException extends AppException {
  CacheException({
    required super.message,
  });
}



class NetworkException extends AppException {
  NetworkException({
    super.message = 'No internet connection. Please check your network.',
  });
}



class UnauthorizedException extends AppException {
  UnauthorizedException({
    super.message = 'Unauthorized access. Please login again.',
    super.statusCode = 401,
  });
}



class ForbiddenException extends AppException {
  ForbiddenException({
    super.message = 'Access forbidden. You don\'t have permission.',
    super.statusCode = 403,
  });
}



class NotFoundException extends AppException {
  NotFoundException({
    super.message = 'Resource not found.',
    super.statusCode = 404,
  });
}



class TimeoutException extends AppException {
  TimeoutException({
    super.message = 'Request timeout. Please try again.',
  });
}



class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  ValidationException({
    super.message = 'Validation failed.',
    this.errors,
    super.statusCode = 422,
  });
}



class ParseException extends AppException {
  ParseException({
    super.message = 'Failed to parse response data.',
  });
}

