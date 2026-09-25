import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/onboarding_data.dart';

class OnboardingController extends Notifier<OnboardingData> {
  @override
  OnboardingData build() => const OnboardingData();

  void setNativeLanguage(String id) {
    state = state.copyWith(nativeLanguageId: id);
  }

  void setLearningLanguage(String id) {
    state = state.copyWith(learningLanguageId: id);
  }

  void setEstimatedLevel(String code) {
    state = state.copyWith(estimatedLevelCode: code);
  }

  void setGoal({required OnboardingGoalType type, required int target}) {
    state = state.copyWith(goalType: type, goalTarget: target);
  }

  void setDailyMinutes(int minutes) {
    state = state.copyWith(dailyMinutes: minutes);
  }

  void reset() {
    state = const OnboardingData();
  }
}

final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingData>(
      OnboardingController.new,
    );
