class SessionAnswerRecord {
  const SessionAnswerRecord({
    required this.questionId,
    required this.chosenIndex,
    required this.isCorrect,
    this.markedReview = false,
    this.timeMs = 0,
  });

  final String questionId;
  final int? chosenIndex; // null if skipped
  final bool isCorrect;
  final bool markedReview;
  final int timeMs;

  factory SessionAnswerRecord.fromJson(Map<String, dynamic> json) {
    return SessionAnswerRecord(
      questionId: json['question_id'] as String,
      chosenIndex: json['chosen_index'] as int?,
      isCorrect: json['is_correct'] as bool? ?? false,
      markedReview: json['marked_review'] as bool? ?? false,
      timeMs: json['time_ms'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'chosen_index': chosenIndex,
        'is_correct': isCorrect,
        'marked_review': markedReview,
        'time_ms': timeMs,
      };
}

class SessionRecord {
  const SessionRecord({
    required this.id,
    required this.startedAt,
    required this.finishedAt,
    required this.plannedCount,
    required this.plannedMinutes,
    required this.topicSlugs,
    required this.score,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.marksLost,
    required this.answers,
  });

  final String id;
  final DateTime startedAt;
  final DateTime finishedAt;
  final int plannedCount;
  final int plannedMinutes;
  final List<String> topicSlugs;
  final double score;
  final int correct;
  final int wrong;
  final int skipped;
  final double marksLost;
  final List<SessionAnswerRecord> answers;

  int get totalQuestions => correct + wrong + skipped;
  double get accuracy => totalQuestions > 0 ? (correct / totalQuestions) * 100 : 0.0;
  Duration get timeTaken => finishedAt.difference(startedAt);

  factory SessionRecord.fromJson(Map<String, dynamic> json) {
    return SessionRecord(
      id: json['id'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      finishedAt: DateTime.parse(json['finished_at'] as String),
      plannedCount: json['planned_count'] as int? ?? 0,
      plannedMinutes: json['planned_minutes'] as int? ?? 0,
      topicSlugs: (json['topic_slugs'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      correct: json['correct'] as int? ?? 0,
      wrong: json['wrong'] as int? ?? 0,
      skipped: json['skipped'] as int? ?? 0,
      marksLost: (json['marks_lost'] as num?)?.toDouble() ?? 0.0,
      answers: (json['answers'] as List<dynamic>?)
              ?.map((e) => SessionAnswerRecord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'started_at': startedAt.toIso8601String(),
        'finished_at': finishedAt.toIso8601String(),
        'planned_count': plannedCount,
        'planned_minutes': plannedMinutes,
        'topic_slugs': topicSlugs,
        'score': score,
        'correct': correct,
        'wrong': wrong,
        'skipped': skipped,
        'marks_lost': marksLost,
        'answers': answers.map((a) => a.toJson()).toList(),
      };
}
