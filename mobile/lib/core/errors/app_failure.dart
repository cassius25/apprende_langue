import 'package:equatable/equatable.dart';

sealed class AppFailure extends Equatable {
  const AppFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server error', this.statusCode]);
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Unauthorized']);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message, this.details);
  final Map<String, dynamic>? details;

  @override
  List<Object?> get props => [message, details];
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Not found']);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Local storage error']);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([super.message = 'Unexpected error']);
}
