import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/confetti.dart';
import '../../core/mascot.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../data/models/question.dart';
import '../../data/models/session_result.dart';
import '../../data/repository/pookie_repository.dart';
import '../quiz/quiz_screen.dart';
import '../session_setup/topics.dart';
import 'review_screen.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({
    super.key,
    required this.session,
    required this.questions,
    required this.repository,
  });

  final SessionRecord session;
  final List<Question> questions;
  final PookieRepository repository;

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _showOverlay = true;

  SessionRecord get session => widget.session;
  List<Question> get questions => widget.questions;
  PookieRepository get repository => widget.repository;

  @override
  Widget build(BuildContext context) {
    final accuracyPercent = session.accuracy.round();
    final timeTakenMinutes = session.timeTaken.inMinutes;
    final timeTakenSeconds = session.timeTaken.inSeconds % 60;

    MascotPose pose = MascotPose.fainted;
    String message = 'এবার ঠিকমতো পড়তে হবে! হার মানো না!';

    if (accuracyPercent == 100) {
      pose = MascotPose.dancing;
      message = 'পারফেক্ট! তুমি একটা সুপারস্টার!';
    } else if (accuracyPercent >= 80) {
      pose = MascotPose.superHappy;
      message = 'অসাধারণ ফলাফল! তুমি তো তুখোড় প্রস্তুতি নিচ্ছো!';
    } else if (accuracyPercent >= 60) {
      pose = MascotPose.happy;
      message = 'দারুণ প্রচেষ্টা! এবার ব্যাখ্যাগুলো দেখে আরও গুছিয়ে নিই।';
    } else if (accuracyPercent >= 30) {
      pose = MascotPose.crying;
      message = 'মন খারাপ করো না! ভুলগুলো থেকেই পরের ধাপটা শিখি।';
    }

    // Wrong questions list for retry
    final wrongQuestionIds = session.answers
        .where((a) => !a.isCorrect && a.chosenIndex != null)
        .map((a) => a.questionId)
        .toSet();
    final wrongQuestions =
        questions.where((q) => wrongQuestionIds.contains(q.id)).toList();

    // Topic breakdown
    final topicAttempts = <String, int>{};
    final topicCorrects = <String, int>{};
    for (final ans in session.answers) {
      final q = questions.firstWhere((item) => item.id == ans.questionId);
      topicAttempts[q.topic] = (topicAttempts[q.topic] ?? 0) + 1;
      if (ans.isCorrect) {
        topicCorrects[q.topic] = (topicCorrects[q.topic] ?? 0) + 1;
      }
    }

    Widget content = PookieScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ফলাফল'),
        actions: [
          IconButton(
            tooltip: 'হোমে ফিরে যাও',
            icon: const Icon(Icons.home_rounded),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: PookieColors.blush,
                borderRadius: BorderRadius.circular(16)),
            child: Row(children: [
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text('আরেক ধাপ এগিয়ে গেলে!',
                        style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 8),
                    Text(message),
                  ])),
              const SizedBox(width: 8),
              LiveMascot(pose: pose, size: 84),
            ]),
          ),
          const SizedBox(height: 24),
          Text('আজকের অনুশীলনের হিসাব',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: PookieColors.surface,
                borderRadius: BorderRadius.circular(16)),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('তোমার অর্জিত নম্বর',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              AnimatedCountUpScore(
                score: session.score,
                total: session.plannedCount,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: PookieColors.primaryDeep,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: _StatColumn(
                        label: 'সঠিক',
                        value: toBn(session.correct),
                        color: PookieColors.ok)),
                Expanded(
                    child: _StatColumn(
                        label: 'ভুল',
                        value: toBn(session.wrong),
                        color: PookieColors.wrong)),
                Expanded(
                    child: _StatColumn(
                        label: 'বাদ',
                        value: toBn(session.skipped),
                        color: PookieColors.muted)),
              ]),
              const SizedBox(height: 20),
              Text(
                  '${toBn(session.correct)} সঠিক − ${formatScore(session.marksLost)} কাটা = ${formatScore(session.score)} নম্বর',
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('নেগেটিভ মার্কিং: −${formatScore(session.marksLost)}',
                  style: const TextStyle(color: PookieColors.wrong)),
              const SizedBox(height: 16),
              Wrap(spacing: 16, runSpacing: 8, children: [
                AnimatedCountUpText(
                  endValue: accuracyPercent,
                  prefix: 'নির্ভুলতা: ',
                  suffix: '%',
                  style: const TextStyle(
                      color: PookieColors.primaryDeep,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                    'সময়: ${toBn(timeTakenMinutes)} মিনিট ${toBn(timeTakenSeconds)} সেকেন্ড',
                    style: const TextStyle(color: PookieColors.muted)),
              ]),
            ]),
          ),
          const SizedBox(height: 24),
          // Topic Breakdown
          const Text(
            'বিষয়ভিত্তিক পর্যালোচনা',
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: PookieColors.ink),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: PookieColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: PookieColors.border),
            ),
            child: Column(
              children: [
                for (final entry in topicAttempts.entries) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: Text(
                              getTopicLabel(entry.key),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: PookieColors.ink),
                            )),
                            const SizedBox(width: 12),
                            Text(
                              '${toBn(topicCorrects[entry.key] ?? 0)} / ${toBn(entry.value)}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: PookieColors.primaryDeep),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        AnimatedProgressBar(
                          value: (topicCorrects[entry.key] ?? 0) / entry.value,
                          backgroundColor: PookieColors.blush,
                          color: PookieColors.primaryDeep,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('এবার কী শিখবো?', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (wrongQuestions.isNotEmpty) ...[
            PookiePressable(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      questions: wrongQuestions,
                      plannedMinutes:
                          (wrongQuestions.length * 0.75).ceil().clamp(5, 20),
                      topicSlugs:
                          wrongQuestions.map((q) => q.topic).toSet().toList(),
                      repository: repository,
                    ),
                  ),
                );
              },
              child: FilledButton.icon(
                icon: const Icon(Icons.refresh_rounded, size: 22),
                style: FilledButton.styleFrom(
                  backgroundColor: PookieColors.primaryDeep,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(
                        questions: wrongQuestions,
                        plannedMinutes:
                            (wrongQuestions.length * 0.75).ceil().clamp(5, 20),
                        topicSlugs:
                            wrongQuestions.map((q) => q.topic).toSet().toList(),
                        repository: repository,
                      ),
                    ),
                  );
                },
                label: Text('আবার করি (${toBn(wrongQuestions.length)} টি)'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          PookiePressable(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ReviewScreen(
                    session: session,
                    questions: questions,
                    repository: repository,
                  ),
                ),
              );
            },
            child: FilledButton.icon(
              icon: const Icon(Icons.checklist_rounded, size: 22),
              style: FilledButton.styleFrom(
                backgroundColor: PookieColors.blush,
                foregroundColor: PookieColors.ink,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ReviewScreen(
                      session: session,
                      questions: questions,
                      repository: repository,
                    ),
                  ),
                );
              },
              label: const Text('উত্তর ও ব্যাখ্যা দেখো'),
            ),
          ),
          const SizedBox(height: 12),
          PookiePressable(
            onTap: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            child: OutlinedButton.icon(
              icon: const Icon(Icons.home_rounded, size: 20),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: PookieColors.blush, width: 2),
              ),
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
              label: const Text('হোমে ফিরে যাও',
                  style: TextStyle(color: PookieColors.ink)),
            ),
          ),
        ],
      ),
    );


    // Wrap confetti for high scorers
    Widget page = content;
    if (accuracyPercent >= 80 && !MediaQuery.disableAnimationsOf(context)) {
      page = PookieConfetti(child: content);
    }

    // Show dramatic mascot overlay on first view
    if (_showOverlay) {
      return Stack(
        children: [
          page,
          Positioned.fill(
            child: ResultMascotOverlay(
              scorePercent: accuracyPercent,
              onDismiss: () => setState(() => _showOverlay = false),
            ),
          ),
        ],
      );
    }

    return page;
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn(
      {required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                color: PookieColors.muted,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}
