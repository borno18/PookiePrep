import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/date_utils.dart';
import '../../core/mascot.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../core/study_widgets.dart';
import '../../data/models/session_result.dart';
import '../../data/repository/pookie_repository.dart';
import '../session_setup/topics.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key, required this.repository});
  final PookieRepository repository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final history = repository.sessionHistory;
        final streak = repository.currentStreak;
        final topicAcc = repository.topicAccuracy;
        final weakTopic = repository.recommendedWeakTopic;
        final totalQuestions =
            history.fold<int>(0, (sum, s) => sum + s.totalQuestions);
        final totalCorrect = history.fold<int>(0, (sum, s) => sum + s.correct);
        final overallAccuracy = totalQuestions > 0
            ? ((totalCorrect / totalQuestions) * 100).round()
            : 0;
        final questionTopics = {
          for (final q in repository.allQuestions) q.id: q.topic
        };
        final practicedTopics = <String>{};
        for (final session in history) {
          for (final answer in session.answers) {
            final topic = questionTopics[answer.questionId];
            if (topic != null) practicedTopics.add(topic);
          }
        }
        final text = Theme.of(context).textTheme;
        return PookieScaffold(
          appBar: AppBar(title: const Text('অগ্রগতি ও পরিসংখ্যান')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              StudyIntro(
                title: streak > 0
                    ? '${toBn(streak)} দিন ধরে এগিয়ে চলা'
                    : 'নিজের গতিতে এগিয়ে যাও',
                description:
                    'প্রতিটি সেশন তোমার শেখার গল্পের অংশ। এখানে নিজের চর্চা আর বিষয়ভিত্তিক নির্ভুলতা দেখতে পারবে।',
                icon: Icons.insights_rounded,
                color: PookieColors.ok,
                pose: history.isEmpty
                    ? MascotPose.encourage
                    : MascotPose.cheering,
              ),
              const SizedBox(height: 24),
              if (history.isEmpty) ...[
                const StudyEmptyState(
                  title: 'প্রথম সেশনেই শুরু হবে গল্প',
                  description:
                      'এখনও কোনো সেশন সম্পন্ন করোনি। একটি কুইজ শেষ করলে তোমার প্রশ্ন সংখ্যা, নির্ভুলতা আর ইতিহাস এখানে দেখা যাবে।',
                  pose: MascotPose.encourage,
                ),
                const SizedBox(height: 24),
              ] else ...[
                StudySection(
                  title: 'এখন পর্যন্ত তোমার চর্চা',
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: BoxDecoration(
                        color: PookieColors.mint,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(children: [
                      _StatLine(
                          title: 'মোট সেশন',
                          value: '${toBn(history.length)} টি',
                          icon: Icons.task_alt_rounded),
                      const Divider(height: 1),
                      _StatLine(
                          title: 'মোট প্রশ্ন',
                          value: '${toBn(totalQuestions)} টি',
                          icon: Icons.quiz_outlined),
                      const Divider(height: 1),
                      _StatLine(
                          title: 'গড় নির্ভুলতা',
                          value: '${toBn(overallAccuracy)}%',
                          icon: Icons.check_circle_outline_rounded),
                    ]),
                  ),
                ),
                const SizedBox(height: 28),
              ],
              if (weakTopic != null) ...[
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                      color: PookieColors.apricot,
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('পরের চর্চায় একটু সময় দাও',
                            style: text.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(
                            '${getTopicLabel(weakTopic)}—এই বিষয়ে জমা ভুলগুলো আবার দেখলে কাজে দেবে।',
                            style: text.bodyMedium),
                      ]),
                ),
                const SizedBox(height: 28),
              ],
              StudySection(
                title: 'বিষয়ভিত্তিক নির্ভুলতা',
                subtitle:
                    'সঠিক উত্তরের হার। এখনও চর্চা না করা বিষয় আলাদা করে দেখানো হয়েছে।',
                child: Column(children: [
                  for (final slug in allTopicSlugs)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(getTopicLabel(slug),
                                      style: text.titleMedium),
                                  Text(
                                      practicedTopics.contains(slug)
                                          ? '${toBn((topicAcc[slug] ?? 0).round())}%'
                                          : 'এখনও চর্চা হয়নি',
                                      style: text.bodyMedium?.copyWith(
                                          color: practicedTopics.contains(slug)
                                              ? PookieColors.ok
                                              : PookieColors.muted)),
                                ]),
                            if (practicedTopics.contains(slug)) ...[
                              const SizedBox(height: 8),
                              Semantics(
                                label:
                                    '${getTopicLabel(slug)} নির্ভুলতা ${toBn((topicAcc[slug] ?? 0).round())} শতাংশ',
                                child: LinearProgressIndicator(
                                  value:
                                      ((topicAcc[slug] ?? 0) / 100).clamp(0, 1),
                                  minHeight: 8,
                                  borderRadius: BorderRadius.circular(8),
                                  backgroundColor: PookieColors.mint,
                                  color: PookieColors.ok,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            const Divider(height: 1),
                          ]),
                    ),
                ]),
              ),
              if (history.isNotEmpty) ...[
                const SizedBox(height: 28),
                StudySection(
                  title: 'সাম্প্রতিক সেশনের ইতিহাস',
                  subtitle: 'শেষ ${toBn(history.take(10).length)}টি সেশন',
                  child: Column(children: [
                    for (final record in history.take(10))
                      _HistoryTile(record: record),
                  ]),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _StatLine extends StatelessWidget {
  const _StatLine(
      {required this.title, required this.value, required this.icon});
  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(children: [
        Icon(icon, color: PookieColors.ok, size: 24),
        const SizedBox(width: 12),
        Expanded(
            child: Text(title, style: Theme.of(context).textTheme.bodyLarge)),
        const SizedBox(width: 8),
        Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.titleLarge)),
      ]),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.record});
  final SessionRecord record;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(formatBnDate(record.finishedAt),
            style: text.bodyMedium?.copyWith(color: PookieColors.muted)),
        const SizedBox(height: 6),
        Text(
            'স্কোর: ${formatScore(record.score)} / ${toBn(record.plannedCount)}',
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
            'নির্ভুলতা: ${toBn(record.accuracy.round())}% · সঠিক: ${toBn(record.correct)} · ভুল: ${toBn(record.wrong)} · বাদ: ${toBn(record.skipped)}',
            style: text.bodyMedium),
        const SizedBox(height: 14),
        const Divider(height: 1),
      ]),
    );
  }
}
