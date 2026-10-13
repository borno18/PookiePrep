import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/date_utils.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../data/models/question.dart';
import '../../data/models/session_result.dart';
import '../../data/repository/pookie_repository.dart';
import '../session_setup/topics.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({
    super.key,
    required this.session,
    required this.questions,
    required this.repository,
  });

  final SessionRecord session;
  final List<Question> questions;
  final PookieRepository repository;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  void _reportQuestion(Question question) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Expanded(
                child: Text('প্রশ্ন রিপোর্ট করো',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: PookieColors.ink))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('প্রশ্ন আইডি: ${question.id}',
                style:
                    const TextStyle(fontSize: 12, color: PookieColors.muted)),
            const SizedBox(height: 8),
            const Text(
              'এই প্রশ্নে কোনো তথ্য বা উত্তরে অসঙ্গতি থাকলে বর্ণনা লিখে রাখো। পরবর্তী সাপ্তাহিক প্যাকে এটি সংশোধন করা হবে।',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: 'তোমার মন্তব্য বা সংশোধন...',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: PookieColors.blush.withOpacity(0.5),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('বাতিল'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('ধন্যবাদ! রিপোর্ট গৃহীত হয়েছে')),
              );
            },
            style: FilledButton.styleFrom(
                backgroundColor: PookieColors.primaryDeep,
                foregroundColor: Colors.white),
            child: const Text('জমা দিন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => PookieScaffold(
        appBar: AppBar(title: const Text('উত্তরমালা ও ব্যাখ্যা')),
        body: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          itemCount: widget.questions.length + 1,
          separatorBuilder: (_, __) => const SizedBox(height: 24),
          itemBuilder: (context, position) {
            if (position == 0) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('উত্তর থেকে শেখা',
                        style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    const Text(
                        'সঠিক উত্তর আর ব্যাখ্যা মিলিয়ে দেখো। পরে পড়তে চাইলে বুকমার্ক করে রাখো।',
                        style: TextStyle(color: PookieColors.muted)),
                    const SizedBox(height: 16),
                    Wrap(spacing: 16, runSpacing: 8, children: [
                      Text('সঠিক ${toBn(widget.session.correct)}',
                          style: const TextStyle(
                              color: PookieColors.ok,
                              fontWeight: FontWeight.w600)),
                      Text('ভুল ${toBn(widget.session.wrong)}',
                          style: const TextStyle(
                              color: PookieColors.wrong,
                              fontWeight: FontWeight.w600)),
                      Text('বাদ ${toBn(widget.session.skipped)}',
                          style: const TextStyle(
                              color: PookieColors.muted,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ]);
            }
            final index = position - 1;
            final question = widget.questions[index];
            final answerRecord = widget.session.answers.firstWhere(
                (a) => a.questionId == question.id,
                orElse: () => SessionAnswerRecord(
                    questionId: question.id,
                    chosenIndex: null,
                    isCorrect: false));
            final chosen = answerRecord.chosenIndex;
            final isCorrect = answerRecord.isCorrect;
            final isSkipped = chosen == null;
            final state = widget.repository.getQuestionState(question.id);
            final statusColor = isCorrect
                ? PookieColors.ok
                : (isSkipped ? PookieColors.muted : PookieColors.wrong);
            final penalty = widget.session.wrong > 0
                ? widget.session.marksLost / widget.session.wrong
                : widget.repository.settings.negativeMark;
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: PookieColors.surface,
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(
                          isCorrect
                              ? Icons.check_circle_outline_rounded
                              : (isSkipped
                                  ? Icons.remove_circle_outline_rounded
                                  : Icons.cancel_outlined),
                          color: statusColor,
                          size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(
                              isCorrect
                                  ? 'সঠিক (+১)'
                                  : (isSkipped
                                      ? 'বাদ দেওয়া (০)'
                                      : 'ভুল (−${formatScore(penalty)})'),
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.w600))),
                      IconButton(
                        tooltip:
                            state.bookmarked ? 'বুকমার্ক সরাও' : 'বুকমার্ক করো',
                        icon: Icon(
                            state.bookmarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_border_rounded,
                            color: state.bookmarked
                                ? PookieColors.accent
                                : PookieColors.muted),
                        onPressed: () async {
                          await widget.repository.toggleBookmark(question.id);
                          if (mounted) setState(() {});
                        },
                      ),
                    ]),
                    Text(getTopicLabel(question.topic),
                        style: const TextStyle(
                            color: PookieColors.primaryDeep,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Text('${toBn(index + 1)}. ${question.text}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                fontWeight: FontWeight.w600, height: 1.6)),
                    const SizedBox(height: 16),
                    for (int i = 0; i < question.options.length; i++) ...[
                      _ReviewOptionTile(
                          prefix: bnOptionLetters[i],
                          text: question.options[i],
                          isRightAnswer: i == question.answerIndex,
                          isChosen: chosen == i),
                      const SizedBox(height: 8),
                    ],
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 16),
                    Row(children: [
                      const Icon(Icons.lightbulb_outline_rounded,
                          color: PookieColors.accent, size: 20),
                      const SizedBox(width: 8),
                      Text('কেন এই উত্তর?',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: PookieColors.accent))
                    ]),
                    const SizedBox(height: 8),
                    Text(question.explanation,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(height: 1.65)),
                    if (question.eventDate != null ||
                        question.sources.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      if (question.eventDate != null)
                        Text(
                            'সংবাদের তারিখ: ${formatIsoDate(question.eventDate)}',
                            style: const TextStyle(color: PookieColors.muted)),
                      for (final source in question.sources)
                        Text('উৎস: ${source.name}',
                            style: const TextStyle(color: PookieColors.muted)),
                    ],
                    const SizedBox(height: 8),
                    Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                            icon: const Icon(Icons.flag_outlined, size: 18),
                            label: const Text('ভুল রিপোর্ট'),
                            onPressed: () => _reportQuestion(question))),
                  ]),
            );
          },
        ),
      );
}

class _ReviewOptionTile extends StatelessWidget {
  const _ReviewOptionTile({
    required this.prefix,
    required this.text,
    required this.isRightAnswer,
    required this.isChosen,
  });

  final String prefix;
  final String text;
  final bool isRightAnswer;
  final bool isChosen;

  @override
  Widget build(BuildContext context) {
    Color bg = Colors.white;
    Color border = PookieColors.blush;
    const textColor = PookieColors.ink;
    Widget? trailing;

    if (isRightAnswer) {
      bg = PookieColors.ok.withOpacity(0.18);
      border = PookieColors.ok;
      trailing = const Icon(Icons.check_circle_rounded,
          color: PookieColors.ok, size: 20);
    } else if (isChosen && !isRightAnswer) {
      bg = PookieColors.wrong.withOpacity(0.18);
      border = PookieColors.wrong;
      trailing =
          const Icon(Icons.cancel_rounded, color: PookieColors.wrong, size: 20);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isRightAnswer
                  ? PookieColors.ok
                  : (isChosen ? PookieColors.wrong : PookieColors.blush),
              shape: BoxShape.circle,
            ),
            child: Text(
              prefix,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color:
                    isRightAnswer || isChosen ? Colors.white : PookieColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(text,
                  style: TextStyle(
                      fontWeight: isRightAnswer || isChosen
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: textColor)),
              if (isRightAnswer || isChosen) ...[
                const SizedBox(height: 4),
                Text(
                    isRightAnswer
                        ? (isChosen ? 'সঠিক উত্তর · তোমার উত্তর' : 'সঠিক উত্তর')
                        : 'তোমার উত্তর',
                    style: TextStyle(
                        color: isRightAnswer
                            ? PookieColors.ok
                            : PookieColors.wrong,
                        fontWeight: FontWeight.w600)),
              ],
            ]),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing],
        ],
      ),
    );
  }
}
