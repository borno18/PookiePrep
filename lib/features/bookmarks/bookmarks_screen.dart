import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/mascot.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../core/study_widgets.dart';
import '../../data/models/question.dart';
import '../../data/repository/pookie_repository.dart';
import '../quiz/quiz_screen.dart';
import '../session_setup/topics.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key, required this.repository});

  final PookieRepository repository;

  void _startBookmarksQuiz(BuildContext context, List<Question> bookmarked) {
    if (bookmarked.isEmpty) return;
    final count = bookmarked.length.clamp(5, 30);
    final quizQuestions = (List.of(bookmarked)..shuffle()).take(count).toList();
    final minutes = (quizQuestions.length * 0.75).ceil().clamp(5, 20);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          questions: quizQuestions,
          plannedMinutes: minutes,
          topicSlugs: quizQuestions.map((q) => q.topic).toSet().toList(),
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
        final questions = repository.getBookmarkedQuestions();
        return PookieScaffold(
          appBar: AppBar(title: const Text('বুকমার্ক সংগ্রহ')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              if (questions.isEmpty)
                const StudyEmptyState(
                  title: 'তোমার নিজের প্রশ্ন সংগ্রহ',
                  description:
                      'কুইজ বা উত্তর পর্যালোচনার সময় বুকমার্ক আইকনে চাপ দাও। গুরুত্বপূর্ণ প্রশ্নগুলো এখানে থাকবে, যখন ইচ্ছে আবার পড়তে পারবে।',
                  pose: MascotPose.thinking,
                )
              else ...[
                StudyIntro(
                  title: 'আবার পড়ার জন্য রাখা',
                  description:
                      '${toBn(questions.length)}টি সংরক্ষিত প্রশ্ন। উত্তর দেখে রিভিশন দাও, অথবা নিজেকে যাচাই করো।',
                  icon: Icons.bookmarks_rounded,
                  color: PookieColors.accent,
                  pose: MascotPose.thinking,
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => _startBookmarksQuiz(context, questions),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('অনুশীলন কুইজ'),
                ),
                const SizedBox(height: 28),
                Text('তোমার সংরক্ষিত প্রশ্ন',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                for (var i = 0; i < questions.length; i++) ...[
                  _BookmarkCard(
                      index: i + 1,
                      question: questions[i],
                      repository: repository),
                  const SizedBox(height: 16),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  const _BookmarkCard(
      {required this.index, required this.question, required this.repository});
  final int index;
  final Question question;
  final PookieRepository repository;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: PookieColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Text(getTopicLabel(question.topic),
                    style: text.bodyMedium?.copyWith(
                        color: PookieColors.accent,
                        fontWeight: FontWeight.w600))),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'বুকমার্ক সরান',
              icon: const Icon(Icons.bookmark_remove_rounded),
              color: PookieColors.accent,
              onPressed: () => repository.toggleBookmark(question.id),
            ),
          ]),
          const SizedBox(height: 8),
          Text('${toBn(index)}. ${question.text}',
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Icon(Icons.check_circle_outline_rounded,
                color: PookieColors.ok, size: 22),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('সঠিক উত্তর',
                      style: text.bodyMedium?.copyWith(
                          color: PookieColors.ok, fontWeight: FontWeight.w600)),
                  Text(question.options[question.answerIndex],
                      style: text.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ])),
          ]),
          if (question.explanation.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1),
            const SizedBox(height: 14),
            Text(question.explanation, style: text.bodyMedium),
          ],
        ]),
      ),
    );
  }
}
