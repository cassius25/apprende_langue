import '../../domain/entities/language.dart';

class LanguageModel {
  const LanguageModel({required this.json});
  final Map<String, dynamic> json;

  factory LanguageModel.fromApi(Map<String, dynamic> json) =>
      LanguageModel(json: json);

  Language toEntity() => Language(
    id: json['id'] as String,
    code: json['code'] as String,
    name: json['name'] as String,
    nativeName: json['nativeName'] as String? ?? json['name'] as String,
    flagEmoji: json['flagEmoji'] as String?,
    isActive: json['isActive'] as bool? ?? true,
  );
}
