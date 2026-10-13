class QuestionSource {
  const QuestionSource({
    required this.name,
    required this.url,
  });

  final String name;
  final String url;

  factory QuestionSource.fromJson(Map<String, dynamic> json) {
    return QuestionSource(
      name: json['name'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'url': url,
      };
}

class Question {
  const Question({
    required this.id,
    required this.kind, // 'static' or 'current'
    required this.topic,
    this.subtopic,
    required this.text,
    required this.options,
    required this.answerIndex,
    required this.explanation,
    this.difficulty = 1,
    this.eventDate,
    this.expiresAt,
    this.sources = const [],
    this.retired = false,
    this.packId,
  });

  final String id;
  final String kind;
  final String topic;
  final String? subtopic;
  final String text;
  final List<String> options;
  final int answerIndex;
  final String explanation;
  final int difficulty;
  final String? eventDate;
  final String? expiresAt;
  final List<QuestionSource> sources;
  final bool retired;
  final String? packId;

  bool get isCurrent => kind == 'current';

  factory Question.fromJson(Map<String, dynamic> json, {String? packId}) {
    return Question(
      id: json['id'] as String,
      kind: json['kind'] as String? ?? 'static',
      topic: json['topic'] as String,
      subtopic: json['subtopic'] as String?,
      text: json['text'] as String,
      options: (json['options'] as List<dynamic>).map((e) => e.toString()).toList(),
      answerIndex: json['answer_index'] as int,
      explanation: json['explanation'] as String? ?? '',
      difficulty: json['difficulty'] as int? ?? 1,
      eventDate: json['event_date'] as String?,
      expiresAt: json['expires_at'] as String?,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => QuestionSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      retired: json['retired'] as bool? ?? false,
      packId: packId ?? json['pack_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind,
        'topic': topic,
        'subtopic': subtopic,
        'text': text,
        'options': options,
        'answer_index': answerIndex,
        'explanation': explanation,
        'difficulty': difficulty,
        'event_date': eventDate,
        'expires_at': expiresAt,
        'sources': sources.map((s) => s.toJson()).toList(),
        'retired': retired,
        'pack_id': packId,
      };
}
