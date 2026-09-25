import 'package:equatable/equatable.dart';

class CourseModule extends Equatable {
  const CourseModule({
    required this.id,
    required this.title,
    required this.order,
    this.description,
    this.lessonCount = 0,
  });

  final String id;
  final String title;
  final String? description;
  final int order;
  final int lessonCount;

  @override
  List<Object?> get props => [id, title, order];
}

class Course extends Equatable {
  const Course({
    required this.id,
    required this.title,
    required this.languageId,
    required this.levelId,
    required this.levelCode,
    required this.languageCode,
    this.description,
    this.order = 0,
    this.isPublished = false,
    this.moduleCount = 0,
    this.lessonCount = 0,
    this.modules = const [],
  });

  final String id;
  final String title;
  final String? description;
  final String languageId;
  final String languageCode;
  final String levelId;
  final String levelCode;
  final int order;
  final bool isPublished;
  final int moduleCount;
  final int lessonCount;

  /// Rempli uniquement par `GET /courses/:id`.
  final List<CourseModule> modules;

  @override
  List<Object?> get props => [id, title];
}
