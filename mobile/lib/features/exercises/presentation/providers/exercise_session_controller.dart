import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/logger.dart';
import '../../domain/entities/exercise.dart';
import '../../domain/entities/exercise_result.dart';
import 'exercise_providers.dart';

// ─────────────────────────────────────────────────────────────
// State
// ─────────────────────────────────────────────────────────────

enum ExerciseSessionStatus {
  loading,
  running,
  showingFeedback,
  finished,
  empty,
  error,
}

class ExerciseSessionState extends Equatable {
  const ExerciseSessionState({
    this.status = ExerciseSessionStatus.loading,
    this.exercises = const [],
    this.currentIndex = 0,
    this.results = const [],
    this.lastCorrection,
    this.errorMessage,
  });

  final ExerciseSessionStatus status;
  final List<Exercise> exercises;
  final int currentIndex;
  final List<SubmitExerciseResult> results;
  final SubmitExerciseResult? lastCorrection;
  final String? errorMessage;

  Exercise? get current =>
      (status == ExerciseSessionStatus.running &&
          currentIndex < exercises.length)
      ? exercises[currentIndex]
      : null;

  int get total => exercises.length;
  int get completed => results.length;
  int get correctCount => results.where((r) => r.isCorrect).length;

  int get overallScore {
    if (results.isEmpty) return 0;
    final sum = results.fold<int>(0, (a, r) => a + r.score);
    return (sum / results.length).round();
  }

  int get xpEarned => results.fold<int>(0, (a, r) => a + r.xpEarned);

  ExerciseSessionState copyWith({
    ExerciseSessionStatus? status,
    List<Exercise>? exercises,
    int? currentIndex,
    List<SubmitExerciseResult>? results,
    SubmitExerciseResult? lastCorrection,
    String? errorMessage,
    bool clearCorrection = false,
  }) {
    return ExerciseSessionState(
      status: status ?? this.status,
      exercises: exercises ?? this.exercises,
      currentIndex: currentIndex ?? this.currentIndex,
      results: results ?? this.results,
      lastCorrection: clearCorrection
          ? null
          : (lastCorrection ?? this.lastCorrection),
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentIndex,
    results.length,
    lastCorrection,
  ];
}

// ─────────────────────────────────────────────────────────────
// Controller
// ─────────────────────────────────────────────────────────────

class ExerciseSessionController extends Notifier<ExerciseSessionState> {
  @override
  ExerciseSessionState build() => const ExerciseSessionState();

  Future<void> start(String lessonId) async {
    state = const ExerciseSessionState(status: ExerciseSessionStatus.loading);

    final result = await ref
        .read(listExercisesForLessonUseCaseProvider)
        .call(lessonId);

    result.fold(
      (f) => state = state.copyWith(
        status: ExerciseSessionStatus.error,
        errorMessage: f.message,
      ),
      (items) {
        if (items.isEmpty) {
          state = state.copyWith(
            status: ExerciseSessionStatus.empty,
            exercises: items,
          );
        } else {
          state = ExerciseSessionState(
            status: ExerciseSessionStatus.running,
            exercises: items,
            currentIndex: 0,
            results: const [],
          );
        }
      },
    );
  }

  /// Soumet une réponse pour l'exercice courant.
  /// `answer` est le payload spécifique au type (voir widgets).
  Future<void> submitCurrent(
    Map<String, dynamic> answer, {
    int? responseTimeMs,
  }) async {
    final ex = state.current;
    if (ex == null) return;

    final result = await ref
        .read(submitExerciseUseCaseProvider)
        .call(
          exerciseId: ex.id,
          answer: answer,
          responseTimeMs: responseTimeMs,
        );

    result.fold(
      (f) {
        AppLogger.w('Exercises: submit failed — ${f.message}');
        state = state.copyWith(
          status: ExerciseSessionStatus.error,
          errorMessage: f.message,
        );
      },
      (correction) {
        state = state.copyWith(
          status: ExerciseSessionStatus.showingFeedback,
          lastCorrection: correction,
          results: [...state.results, correction],
        );
      },
    );
  }

  /// Passe à l'exercice suivant (ou termine la session).
  void next() {
    if (state.status != ExerciseSessionStatus.showingFeedback) return;
    final nextIndex = state.currentIndex + 1;
    if (nextIndex >= state.exercises.length) {
      state = state.copyWith(
        status: ExerciseSessionStatus.finished,
        currentIndex: nextIndex,
        clearCorrection: true,
      );
    } else {
      state = state.copyWith(
        status: ExerciseSessionStatus.running,
        currentIndex: nextIndex,
        clearCorrection: true,
      );
    }
  }

  /// Réessaie de soumettre l'exercice courant (après erreur réseau).
  void retryFromError() {
    if (state.status != ExerciseSessionStatus.error) return;
    state = state.copyWith(status: ExerciseSessionStatus.running);
  }

  void reset() => state = const ExerciseSessionState();
}

final exerciseSessionControllerProvider =
    NotifierProvider<ExerciseSessionController, ExerciseSessionState>(
      ExerciseSessionController.new,
    );
