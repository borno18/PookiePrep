import 'question.dart';

class DigestItem {
  const DigestItem({
    required this.id,
    required this.title,
    required this.fact,
    required this.topic,
    required this.date,
    this.sources = const [],
    this.packId,
  });

  final String id;
  final String title;
  final String fact;
  final String topic;
  final String date;
  final List<QuestionSource> sources;
  final String? packId;

  factory DigestItem.fromJson(Map<String, dynamic> json, {String? packId}) {
    return DigestItem(
      id: json['id'] as String,
      title: json['title'] as String,
      fact: json['fact'] as String,
      topic: json['topic'] as String,
      date: json['date'] as String,
      sources: (json['sources'] as List<dynamic>?)
              ?.map((e) => QuestionSource.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      packId: packId ?? json['pack_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'fact': fact,
        'topic': topic,
        'date': date,
        'sources': sources.map((s) => s.toJson()).toList(),
        'pack_id': packId,
      };
}
