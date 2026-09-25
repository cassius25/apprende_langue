import '../../domain/entities/course.dart';

class CourseModel {
  const CourseModel({required this.json});
  final Map<String, dynamic> json;

  factory CourseModel.fromApi(Map<String, dynamic> json) =>
      CourseModel(json: json);

  Course toEntity() {
    final lang = json['language'] as Map<String, dynamic>? ?? const {};
    final level = json['level'] as Map<String, dynamic>? ?? const {};
    final modules = (json['modules'] as List?) ?? const [];
    return Course(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      languageId: lang['id'] as String? ?? '',
      languageCode: lang['code'] as String? ?? '',
      levelId: level['id'] as String? ?? '',
      levelCode: level['code'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      isPublished: json['isPublished'] as bool? ?? false,
      moduleCount: (json['moduleCount'] as num?)?.toInt() ?? modules.length,
      lessonCount: (json['lessonCount'] as num?)?.toInt() ?? 0,
      modules: modules
          .whereType<Map>()
          .map(
            (m) => CourseModule(
              id: m['id'] as String,
              title: m['title'] as String,
              description: m['description'] as String?,
              order: (m['order'] as num?)?.toInt() ?? 0,
              lessonCount: ((m['lessons'] as List?) ?? const []).length,
            ),
          )
          .toList(growable: false),
    );
  }
}
