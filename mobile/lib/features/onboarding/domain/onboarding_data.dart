import 'package:equatable/equatable.dart';

enum OnboardingGoalType { minutes, words }

class OnboardingData extends Equatable {
  const OnboardingData({
    this.nativeLanguageId,
    this.learningLanguageId,
    this.estimatedLevelCode,
    this.goalType = OnboardingGoalType.minutes,
    this.goalTarget = 10,
    this.dailyMinutes = 10,
  });

  final String? nativeLanguageId;
  final String? learningLanguageId;
  final String? estimatedLevelCode;
  final OnboardingGoalType goalType;
  final int goalTarget;
  final int dailyMinutes;

  OnboardingData copyWith({
    String? nativeLanguageId,
    String? learningLanguageId,
    String? estimatedLevelCode,
    OnboardingGoalType? goalType,
    int? goalTarget,
    int? dailyMinutes,
  }) {
    return OnboardingData(
      nativeLanguageId: nativeLanguageId ?? this.nativeLanguageId,
      learningLanguageId: learningLanguageId ?? this.learningLanguageId,
      estimatedLevelCode: estimatedLevelCode ?? this.estimatedLevelCode,
      goalType: goalType ?? this.goalType,
      goalTarget: goalTarget ?? this.goalTarget,
      dailyMinutes: dailyMinutes ?? this.dailyMinutes,
    );
  }

  @override
  List<Object?> get props => [
    nativeLanguageId,
    learningLanguageId,
    estimatedLevelCode,
    goalType,
    goalTarget,
    dailyMinutes,
  ];
}
