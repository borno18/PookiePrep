import 'package:flutter/material.dart';

import '../../core/date_utils.dart';
import '../../core/mascot.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../core/study_widgets.dart';
import '../../data/models/digest_item.dart';
import '../../data/repository/pookie_repository.dart';
import '../quiz/quiz_screen.dart';
import '../session_setup/topics.dart';

class DigestScreen extends StatelessWidget {
  const DigestScreen({super.key, required this.repository});

  final PookieRepository repository;

  void _startDigestQuiz(BuildContext context) {
    // Current affairs questions
    final currentQuestions = repository.allQuestions
        .where((q) => q.isCurrent || q.topic.startsWith('recent'))
        .toList();

    if (currentQuestions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('পর্যাপ্ত সাম্প্রতিক প্রশ্ন পাওয়া যায়নি')),
      );
      return;
    }

    final quizQuestions =
        (List.of(currentQuestions)..shuffle()).take(10).toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          questions: quizQuestions,
          plannedMinutes: 10,
          topicSlugs: ['recent_national', 'recent_international'],
          repository: repository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: repository,
      builder: (context, _) {
        final digests = repository.digestItems;
        return PookieScaffold(
          appBar: AppBar(title: const Text('এই সপ্তাহের খবর')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              const StudyIntro(
                title: 'খবর পড়ি, মনে রাখি',
                description:
                    'সাম্প্রতিক সাধারণ জ্ঞানের ছোট পাঠ। ঘটনা আর গুরুত্বপূর্ণ তথ্য পড়ে তারপর কুইজে নিজেকে যাচাই করো।',
                icon: Icons.newspaper_rounded,
                color: PookieColors.accent,
                pose: MascotPose.greeting,
              ),
              const SizedBox(height: 24),
              if (digests.isEmpty)
                const StudyEmptyState(
                  title: 'নতুন খবর এখনও আসেনি',
                  description:
                      'নতুন কনটেন্ট প্যাক এলে খবর এখানে পড়তে পারবে। আপাতত সংরক্ষিত সাম্প্রতিক প্রশ্ন দিয়ে অনুশীলন করো।',
                  pose: MascotPose.thinking,
                )
              else ...[
                Text('সাপ্তাহিক তথ্য ও ঘটনাপঞ্জী',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                for (var i = 0; i < digests.length; i++) ...[
                  _DigestArticle(item: digests[i], featured: i == 0),
                  const SizedBox(height: 24),
                ],
              ],
              FilledButton.icon(
                onPressed: () => _startDigestQuiz(context),
                icon: const Icon(Icons.quiz_outlined),
                label: const Text('খবরের কুইজ দাও'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DigestArticle extends StatelessWidget {
  const _DigestArticle({required this.item, required this.featured});
  final DigestItem item;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final article =
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Wrap(spacing: 12, runSpacing: 4, children: [
        Text(getTopicLabel(item.topic),
            style: text.bodyMedium?.copyWith(
                color: PookieColors.accent, fontWeight: FontWeight.w600)),
        Text(formatIsoDate(item.date),
            style: text.bodyMedium?.copyWith(color: PookieColors.muted)),
      ]),
      const SizedBox(height: 10),
      Text(item.title,
          style: (featured ? text.titleLarge : text.titleMedium)
              ?.copyWith(fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      Text(item.fact, style: text.bodyLarge),
      if (item.sources.isNotEmpty) ...[
        const SizedBox(height: 16),
        Text('উৎস: ${item.sources.map((s) => s.name).join(' · ')}',
            style: text.bodyMedium?.copyWith(color: PookieColors.muted)),
      ],
    ]);
    if (!featured) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          article,
          const SizedBox(height: 24),
          const Divider(height: 1),
        ]),
      );
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: PookieColors.lilac, borderRadius: BorderRadius.circular(16)),
      child: article,
    );
  }
}
