/// Marking scheme: +1 correct, -[negativeMark] per wrong answer, 0 for skipped.
class ScoreResult {
  const ScoreResult({
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.marksLost,
    required this.score,
  });

  final int correct;
  final int wrong;
  final int skipped;
  final double marksLost;
  final double score;
}

const defaultNegativeMark = 0.25;

/// [chosen] holds the selected option index per question, or null if skipped.
/// [answers] holds the correct option index per question (same length).
ScoreResult scoreSession({
  required List<int?> chosen,
  required List<int> answers,
  double negativeMark = defaultNegativeMark,
}) {
  assert(chosen.length == answers.length);
  var correct = 0, wrong = 0, skipped = 0;
  for (var i = 0; i < answers.length; i++) {
    final c = chosen[i];
    if (c == null) {
      skipped++;
    } else if (c == answers[i]) {
      correct++;
    } else {
      wrong++;
    }
  }
  final lost = wrong * negativeMark;
  return ScoreResult(
    correct: correct,
    wrong: wrong,
    skipped: skipped,
    marksLost: lost,
    score: correct - lost,
  );
}
