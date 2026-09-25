import 'package:equatable/equatable.dart';

/// Configuration d'une session de révision SRS.
class ReviewSessionConfig extends Equatable {
  const ReviewSessionConfig({
    this.languageId,
    this.batchSize = 20,
    this.includeNew = false,
    this.shuffle = false,
  });

  /// Filtre langue (null = toutes les langues apprises).
  final String? languageId;

  /// Nombre max de cartes dans la session (10 / 20 / 50 / 100).
  final int batchSize;

  /// Inclure les mots jamais vus (NEW) — utilisé pour "découvrir" de nouveaux mots.
  final bool includeNew;

  /// Mélanger les cartes.
  final bool shuffle;

  ReviewSessionConfig copyWith({
    String? languageId,
    bool clearLanguage = false,
    int? batchSize,
    bool? includeNew,
    bool? shuffle,
  }) {
    return ReviewSessionConfig(
      languageId: clearLanguage ? null : (languageId ?? this.languageId),
      batchSize: batchSize ?? this.batchSize,
      includeNew: includeNew ?? this.includeNew,
      shuffle: shuffle ?? this.shuffle,
    );
  }

  Map<String, dynamic> toJson() => {
    'languageId': languageId,
    'batchSize': batchSize,
    'includeNew': includeNew,
    'shuffle': shuffle,
  };

  factory ReviewSessionConfig.fromJson(Map<String, dynamic> json) {
    return ReviewSessionConfig(
      languageId: json['languageId'] as String?,
      batchSize: (json['batchSize'] as num?)?.toInt() ?? 20,
      includeNew: json['includeNew'] as bool? ?? false,
      shuffle: json['shuffle'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [languageId, batchSize, includeNew, shuffle];
}

const reviewBatchSizeOptions = [10, 20, 50, 100];
