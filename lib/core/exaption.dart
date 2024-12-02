class ServerException implements Exception {
  final String message;

  ServerException(this.message);

  @override
  String toString() => message;
}

class DatabaseException implements Exception {
  final String message;

  DatabaseException(this.message);
}

class UnauthorizedException implements Exception {
  final String message;

  UnauthorizedException([this.message = "Unauthorized access"]);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  NetworkException(this.message);

  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  final Map<String, dynamic> errors;

  ValidationException(this.message, {this.errors = const {}});

  @override
  String toString() => 'errors: $errors';
}
