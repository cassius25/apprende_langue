import 'package:equatable/equatable.dart';

enum GoalType { minutes, words }

class DailyGoal extends Equatable {
  const DailyGoal({
    required this.id,
    required this.type,
    required this.target,
    required this.isActive,
  });

  final String id;
  final GoalType type;
  final int target;
  final bool isActive;

  @override
  List<Object?> get props => [id, type, target, isActive];
}

GoalType goalTypeFromString(String raw) =>
    raw.toUpperCase() == 'WORDS' ? GoalType.words : GoalType.minutes;

String goalTypeToApi(GoalType t) => t == GoalType.words ? 'WORDS' : 'MINUTES';
