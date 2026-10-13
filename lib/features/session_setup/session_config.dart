class SessionConfig {
  const SessionConfig({
    required this.topicSlugs,
    required this.questionCount,
    required this.minutes,
    this.onlyUnseen = false,
    this.includeMistakes = false,
    this.onlyCurrent = false,
  });

  final List<String> topicSlugs;
  final int questionCount; // 10, 20 or 30
  final int minutes; // 10..20
  final bool onlyUnseen;
  final bool includeMistakes;
  final bool onlyCurrent;

  static const countOptions = [10, 20, 30];
  static const minMinutes = 10;
  static const maxMinutes = 20;

  /// Suggested time for a question count, clamped to the allowed range.
  static int defaultMinutes(int count) =>
      switch (count) { 10 => 10, 20 => 15, _ => 20 };
}
