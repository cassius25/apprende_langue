import 'package:equatable/equatable.dart';

class Language extends Equatable {
  const Language({
    required this.id,
    required this.code,
    required this.name,
    required this.nativeName,
    this.flagEmoji,
    this.isActive = true,
  });

  final String id;
  final String code;
  final String name;
  final String nativeName;
  final String? flagEmoji;
  final bool isActive;

  @override
  List<Object?> get props => [id, code];
}