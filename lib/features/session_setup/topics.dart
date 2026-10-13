class Topic {
  const Topic(this.slug, this.label);
  final String slug;
  final String label;
}

class TopicGroup {
  const TopicGroup(this.label, this.topics);
  final String label;
  final List<Topic> topics;
}

/// Taxonomy from architecture.md §2.
const topicGroups = <TopicGroup>[
  TopicGroup('বাংলাদেশ', [
    Topic('bd_history', 'বাংলাদেশের ইতিহাস'),
    Topic('bd_liberation_war', 'মুক্তিযুদ্ধ ও স্বাধীনতা'),
    Topic('bd_geography', 'ভূগোল ও পরিবেশ'),
    Topic('bd_economy', 'অর্থনীতি ও অবকাঠামো'),
    Topic('bd_constitution', 'সংবিধান ও সরকার'),
    Topic('bd_culture_sports', 'সংস্কৃতি, ঐতিহ্য ও ক্রীড়া'),
  ]),
  TopicGroup('আন্তর্জাতিক', [
    Topic('intl_geography', 'বিশ্ব ভূগোল'),
    Topic('intl_orgs', 'আন্তর্জাতিক সংস্থা'),
    Topic('intl_treaties', 'চুক্তি, সম্মেলন ও ঐতিহাসিক ঘটনা'),
    Topic('intl_people_events', 'নোবেল, বিশ্বনেতা ও সমসাময়িক ঘটনা'),
  ]),
  TopicGroup('সাম্প্রতিক', [
    Topic('recent_national', 'সাম্প্রতিক (জাতীয়)'),
    Topic('recent_international', 'সাম্প্রতিক (আন্তর্জাতিক)'),
  ]),
];

List<String> get allTopicSlugs => [
      for (final g in topicGroups)
        for (final t in g.topics) t.slug,
    ];

String getTopicLabel(String slug) {
  for (final g in topicGroups) {
    for (final t in g.topics) {
      if (t.slug == slug) return t.label;
    }
  }
  return slug;
}
