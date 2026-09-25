import '../../domain/entities/exercise.dart';

class ExerciseModel {
  const ExerciseModel({required this.json});
  final Map<String, dynamic> json;

  factory ExerciseModel.fromApi(Map<String, dynamic> json) =>
      ExerciseModel(json: json);

  Exercise toEntity({required String lessonId}) {
    final options = (json['options'] as List?) ?? const [];
    final rawData = json['data'];
    return Exercise(
      id: json['id'] as String,
      lessonId: lessonId,
      type: ExerciseType.parse(json['type'] as String? ?? 'MULTIPLE_CHOICE'),
      question: json['question'] as String? ?? '',
      data: rawData is Map ? Map<String, dynamic>.from(rawData) : null,
      order: (json['order'] as num?)?.toInt() ?? 0,
      options: options
          .whereType<Map>()
          .map(
            (m) => ExerciseOption(
              id: m['id'] as String,
              label: m['label'] as String? ?? '',
              order: (m['order'] as num?)?.toInt() ?? 0,
            ),
          )
          .toList(growable: false),
    );
  }
}
