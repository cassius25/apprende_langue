import 'package:dartz/dartz.dart';

import '../errors/app_failure.dart';

/// Alias pratique : `Result<T>` = `Either<AppFailure, T>`.
typedef Result<T> = Either<AppFailure, T>;

/// Sucre syntaxique pour créer les deux cas.
Result<T> success<T>(T value) => Right<AppFailure, T>(value);
Result<T> failure<T>(AppFailure error) => Left<AppFailure, T>(error);

/// Extension pratique pour enchaîner.
extension ResultX<T> on Result<T> {
  /// Renvoie la valeur ou `null` si erreur.
  T? get valueOrNull => fold((_) => null, (v) => v);

  /// Renvoie l'erreur ou `null` si succès.
  AppFailure? get failureOrNull => fold((f) => f, (_) => null);

  /// `true` si succès.
  bool get isSuccess => isRight();

  /// `true` si erreur.
  bool get isFailure => isLeft();

  /// Transforme la valeur de succès en préservant l'erreur.
  Result<R> mapValue<R>(R Function(T value) mapper) =>
      flatMap((v) => success(mapper(v)));

  /// Applique `mapper` à la valeur ou renvoie `fallback`.
  R foldOr<R>(
    R Function(AppFailure failure) onFailure,
    R Function(T value) onSuccess,
  ) => fold(onFailure, onSuccess);
}
