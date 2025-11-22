import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/mock_quiz_questions.dart';
import '../models/quiz_question.dart';

class QuizState {
  final Map<String, int> answers;
  final int currentIndex;
  final bool completed;

  const QuizState({
    required this.answers,
    required this.currentIndex,
    required this.completed,
  });

  int get score {
    int total = 0;
    for (final entry in answers.entries) {
      final question =
          mockQuizQuestions.firstWhere((element) => element.id == entry.key);
      if (entry.value == question.correctIndex) total++;
    }
    return total;
  }

  QuizState copyWith({
    Map<String, int>? answers,
    int? currentIndex,
    bool? completed,
  }) {
    return QuizState(
      answers: answers ?? this.answers,
      currentIndex: currentIndex ?? this.currentIndex,
      completed: completed ?? this.completed,
    );
  }
}

class QuizController {
  final ValueNotifier<QuizState> state =
      ValueNotifier(const QuizState(answers: {}, currentIndex: 0, completed: false));
  final questions = mockQuizQuestions;
  Timer? _autoAdvanceTimer;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('quiz_answers') ?? [];
    final answers = <String, int>{};
    for (final entry in saved) {
      final parts = entry.split(':');
      if (parts.length == 2) {
        final idx = int.tryParse(parts[1]);
        if (idx != null) answers[parts[0]] = idx;
      }
    }
    final completed = answers.length == questions.length;
    state.value = QuizState(
      answers: answers,
      currentIndex: 0,
      completed: completed,
    );
  }

  Future<void> selectAnswer(String id, int selected) async {
    final updated = Map<String, int>.from(state.value.answers)..[id] = selected;
    final completed = updated.length == questions.length;
    state.value = state.value.copyWith(answers: updated, completed: completed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'quiz_answers',
      updated.entries.map((e) => '${e.key}:${e.value}').toList(),
    );
    if (completed) {
      _autoAdvanceTimer?.cancel();
    }
  }

  void setCurrentIndex(int index) {
    state.value = state.value.copyWith(currentIndex: index);
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = Timer(const Duration(seconds: 6), () {
      final nextIndex = (index + 1) % questions.length;
      state.value = state.value.copyWith(currentIndex: nextIndex);
    });
  }

  Future<void> reset() async {
    state.value = const QuizState(answers: {}, currentIndex: 0, completed: false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_answers');
  }

  void dispose() {
    _autoAdvanceTimer?.cancel();
    state.dispose();
  }
}
