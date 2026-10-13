class QuestionState {
  const QuestionState({
    required this.questionId,
    this.timesSeen = 0,
    this.timesCorrect = 0,
    this.lastSeen,
    this.leitnerBox = 1,
    this.bookmarked = false,
    this.isMistake = false,
  });

  final String questionId;
  final int timesSeen;
  final int timesCorrect;
  final DateTime? lastSeen;
  final int leitnerBox;
  final bool bookmarked;
  final bool isMistake;

  QuestionState copyWith({
    int? timesSeen,
    int? timesCorrect,
    DateTime? lastSeen,
    int? leitnerBox,
    bool? bookmarked,
    bool? isMistake,
  }) {
    return QuestionState(
      questionId: questionId,
      timesSeen: timesSeen ?? this.timesSeen,
      timesCorrect: timesCorrect ?? this.timesCorrect,
      lastSeen: lastSeen ?? this.lastSeen,
      leitnerBox: leitnerBox ?? this.leitnerBox,
      bookmarked: bookmarked ?? this.bookmarked,
      isMistake: isMistake ?? this.isMistake,
    );
  }

  factory QuestionState.fromJson(Map<String, dynamic> json) {
    return QuestionState(
      questionId: json['question_id'] as String,
      timesSeen: json['times_seen'] as int? ?? 0,
      timesCorrect: json['times_correct'] as int? ?? 0,
      lastSeen: json['last_seen'] != null
          ? DateTime.tryParse(json['last_seen'] as String)
          : null,
      leitnerBox: json['leitner_box'] as int? ?? 1,
      bookmarked: json['bookmarked'] as bool? ?? false,
      isMistake: json['is_mistake'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'question_id': questionId,
        'times_seen': timesSeen,
        'times_correct': timesCorrect,
        'last_seen': lastSeen?.toIso8601String(),
        'leitner_box': leitnerBox,
        'bookmarked': bookmarked,
        'is_mistake': isMistake,
      };
}
