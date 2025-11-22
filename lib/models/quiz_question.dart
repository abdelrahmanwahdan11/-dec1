class QuizOption {
  final String textEn;
  final String textAr;
  QuizOption({required this.textEn, required this.textAr});
}

class QuizQuestion {
  final String id;
  final String questionEn;
  final String questionAr;
  final List<QuizOption> options;
  final int correctIndex;
  final String explanationEn;
  final String explanationAr;

  QuizQuestion({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.options,
    required this.correctIndex,
    required this.explanationEn,
    required this.explanationAr,
  });
}
