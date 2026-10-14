import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/mascot.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../core/study_widgets.dart';
import '../../data/models/question.dart';
import '../../data/repository/pookie_repository.dart';
import '../quiz/quiz_screen.dart';
import '../session_setup/topics.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({super.key, required this.repository});

  final PookieRepository repository;

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  String? _selectedTopicSlug;

  void _startMistakesQuiz(List<Question> mistakes) {
    if (mistakes.isEmpty) return;
    final count = mistakes.length.clamp(5, 30);
    final quizQuestions =
        (List<Question>.from(mistakes)..shuffle()).take(count).toList();
    final minutes = (quizQuestions.length * 0.75).ceil().clamp(5, 20);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          questions: quizQuestions,
          plannedMinutes: minutes,
          topicSlugs: quizQuestions.map((q) => q.topic).toSet().toList(),
          repository: widget.repository,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.repository,
      builder: (context, _) {
        final allMistakes = widget.repository.getMistakeQuestions();
        final questions = widget.repository
            .getMistakeQuestions(topicSlug: _selectedTopicSlug);
        final topics = allMistakes.map((q) => q.topic).toSet();
        return PookieScaffold(
          appBar: AppBar(title: const Text('ভুল খাতা')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              if (allMistakes.isEmpty)
                const StudyEmptyState(
                  title: 'এখনও কোনো ভুল জমা নেই',
                  description:
                      'কুইজে ভুল হলে প্রশ্নটি এখানে জমা হবে। উত্তর বুঝে আবার অনুশীলন করতে পারবে—একটি ভুলও শেখার সুযোগ।',
                  pose: MascotPose.encourage,
                )
              else ...[
                StudyIntro(
                  title: 'ভুল থেকেই শেখা হোক',
                  description:
                      '${toBn(allMistakes.length)}টি প্রশ্ন আবার দেখার অপেক্ষায়। ছোট ছোট রিভিশনে উত্তরগুলো মনে গেঁথে যাবে।',
                  icon: Icons.auto_stories_rounded,
                  pose: MascotPose.encourage,
                ),
                const SizedBox(height: 20),
                PookiePressable(
                  onTap: questions.isEmpty ? null : () => _startMistakesQuiz(questions),
                  child: FilledButton.icon(
                    onPressed: questions.isEmpty
                        ? null
                        : () => _startMistakesQuiz(questions),
                    icon: const Icon(Icons.replay_rounded),
                    label: const Text('ভুলগুলো আবার করি'),
                  ),
                ),
                const SizedBox(height: 28),
                Text('কোন বিষয় দেখবে?',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  FilterChip(
                    label: Text('সব বিষয় (${toBn(allMistakes.length)})'),
                    selected: _selectedTopicSlug == null,
                    onSelected: (_) =>
                        setState(() => _selectedTopicSlug = null),
                  ),
                  for (final slug in topics)
                    FilterChip(
                      label: Text(getTopicLabel(slug)),
                      selected: _selectedTopicSlug == slug,
                      onSelected: (_) =>
                          setState(() => _selectedTopicSlug = slug),
                    ),
                ]),
                const SizedBox(height: 20),
                if (questions.isEmpty)
                  const StudyEmptyState(
                    title: 'এই বিষয়ে আর ভুল নেই',
                    description: 'অন্য বিষয়ের প্রশ্ন দেখতে সব বিষয় বেছে নাও।',
                    pose: MascotPose.cheering,
                  ),
                for (var i = 0; i < questions.length; i++) ...[
                  _MistakeCard(
                      index: i + 1,
                      question: questions[i],
                      repository: widget.repository),
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

class _MistakeCard extends StatelessWidget {
  const _MistakeCard(
      {required this.index, required this.question, required this.repository});
  final int index;
  final Question question;
  final PookieRepository repository;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final state = repository.getQuestionState(question.id);
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
              tooltip: state.bookmarked ? 'বুকমার্ক সরান' : 'বুকমার্ক করো',
              icon: Icon(state.bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_outline_rounded),
              color: PookieColors.accent,
              onPressed: () => repository.toggleBookmark(question.id),
            ),
          ]),
          Text('রিভিশন বক্স ${toBn(state.leitnerBox)}/৫',
              style: text.bodyMedium?.copyWith(color: PookieColors.muted)),
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
