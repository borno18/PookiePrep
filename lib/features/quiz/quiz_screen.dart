import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/date_utils.dart';
import '../../core/mascot.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../data/models/question.dart';
import '../../data/models/session_result.dart';
import '../../data/repository/pookie_repository.dart';
import '../result/result_screen.dart';
import '../session_setup/topics.dart';
import 'scoring.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    required this.questions,
    required this.plannedMinutes,
    required this.topicSlugs,
    required this.repository,
  });

  final List<Question> questions;
  final int plannedMinutes;
  final List<String> topicSlugs;
  final PookieRepository repository;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  late final List<int?> _chosenAnswers;
  late final Set<int> _markedForReview;
  late final DateTime _startedAt;
  late final int _deadlineEpoch;

  final _questionScroll = ScrollController();
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _submitted = false;
  bool _allowExit = false;
  bool _exitDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _chosenAnswers = List<int?>.filled(widget.questions.length, null);
    _markedForReview = <int>{};
    _startedAt = DateTime.now();

    final totalSeconds = widget.plannedMinutes * 60;
    _deadlineEpoch = _startedAt.millisecondsSinceEpoch + (totalSeconds * 1000);
    _secondsRemaining = totalSeconds;

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final diff = ((_deadlineEpoch - now) / 1000).ceil();
      if (diff <= 0) {
        timer.cancel();
        setState(() => _secondsRemaining = 0);
        _submitSession(autoSubmitted: true);
      } else {
        setState(() => _secondsRemaining = diff);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _questionScroll.dispose();
    super.dispose();
  }

  void _selectOption(int optionIndex) {
    setState(() {
      if (_chosenAnswers[_currentIndex] == optionIndex) {
        _chosenAnswers[_currentIndex] = null; // deselect
      } else {
        _chosenAnswers[_currentIndex] = optionIndex;
      }
    });
  }

  void _toggleMarkForReview() {
    setState(() {
      if (_markedForReview.contains(_currentIndex)) {
        _markedForReview.remove(_currentIndex);
      } else {
        _markedForReview.add(_currentIndex);
      }
    });
  }

  void _goToQuestion(int index) {
    setState(() => _currentIndex = index);
    if (_questionScroll.hasClients) _questionScroll.jumpTo(0);
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      _goToQuestion(_currentIndex + 1);
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      _goToQuestion(_currentIndex - 1);
    }
  }

  Future<void> _confirmSubmit() async {
    final answeredCount = _chosenAnswers.where((e) => e != null).length;
    final total = widget.questions.length;
    final remaining = total - answeredCount;

    final shouldSubmit = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: PookieColors.surface,
        title: const Row(
          children: [
            Icon(Icons.task_alt_rounded, color: PookieColors.primaryDeep),
            SizedBox(width: 8),
            Expanded(
                child: Text('কুইজ জমা দিতে চাও?',
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
            Text(
                'তুমি ${toBn(total)} টির মধ্যে ${toBn(answeredCount)} টি প্রশ্নের উত্তর দিয়েছো।'),
            if (remaining > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'এখনও ${toBn(remaining)} টি প্রশ্ন বাকি রয়েছে!',
                  style: const TextStyle(
                      color: PookieColors.primaryDeep,
                      fontWeight: FontWeight.w600),
                ),
              ),
            if (_markedForReview.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  ' ${toBn(_markedForReview.length)} টি প্রশ্ন পর্যালোচনার জন্য চিহ্নিত আছে।',
                  style: const TextStyle(
                      color: PookieColors.accent, fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('আরও ভাবি',
                style: TextStyle(color: PookieColors.ink)),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: PookieColors.primaryDeep,
              foregroundColor: Colors.white,
              minimumSize: const Size(110, 48),
            ),
            child: const Text('জমা দাও'),
          ),
        ],
      ),
    );

    if (shouldSubmit == true) {
      await _submitSession(autoSubmitted: false);
    }
  }

  Future<void> _submitSession({required bool autoSubmitted}) async {
    if (_submitted) return;
    _submitted = true;
    _timer?.cancel();

    final finishedAt = DateTime.now();
    final correctAnswers = widget.questions.map((q) => q.answerIndex).toList();
    final negMark = widget.repository.settings.negativeMark;

    final result = scoreSession(
      chosen: _chosenAnswers,
      answers: correctAnswers,
      negativeMark: negMark,
    );

    final answerRecords = <SessionAnswerRecord>[];
    for (int i = 0; i < widget.questions.length; i++) {
      final chosen = _chosenAnswers[i];
      final isCorrect =
          chosen != null && chosen == widget.questions[i].answerIndex;
      answerRecords.add(
        SessionAnswerRecord(
          questionId: widget.questions[i].id,
          chosenIndex: chosen,
          isCorrect: isCorrect,
          markedReview: _markedForReview.contains(i),
        ),
      );
    }

    final sessionRecord = SessionRecord(
      id: 'session_${finishedAt.millisecondsSinceEpoch}',
      startedAt: _startedAt,
      finishedAt: finishedAt,
      plannedCount: widget.questions.length,
      plannedMinutes: widget.plannedMinutes,
      topicSlugs: widget.topicSlugs,
      score: result.score,
      correct: result.correct,
      wrong: result.wrong,
      skipped: result.skipped,
      marksLost: result.marksLost,
      answers: answerRecords,
    );

    await widget.repository.recordSession(sessionRecord);

    if (!mounted) return;

    if (autoSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('সময় শেষ! কুইজ স্বয়ংক্রিয়ভাবে জমা হয়েছে'),
          backgroundColor: PookieColors.primaryDeep,
        ),
      );
    }

    final quizRoute = ModalRoute.of(context);
    Navigator.of(context).popUntil((route) => route == quizRoute);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          session: sessionRecord,
          questions: widget.questions,
          repository: widget.repository,
        ),
      ),
    );
  }

  void _showPalette() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      backgroundColor: PookieColors.surface,
      builder: (ctx) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Wrap(
                spacing: 16,
                runSpacing: 4,
                children: [
                  Text('প্রশ্ন প্যালেট',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: PookieColors.ink)),
                  Text('যেকোনো প্রশ্নে লাফ দাও',
                      style:
                          TextStyle(fontSize: 12, color: PookieColors.muted)),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(widget.questions.length, (idx) {
                  final isAnswered = _chosenAnswers[idx] != null;
                  final isReview = _markedForReview.contains(idx);
                  final isCurrent = idx == _currentIndex;

                  Color bg = PookieColors.blush;
                  Color textColor = PookieColors.ink;
                  Border? border;

                  if (isCurrent) {
                    border =
                        Border.all(color: PookieColors.primaryDeep, width: 2.5);
                  }

                  if (isAnswered) {
                    bg = PookieColors.primary;
                    textColor = PookieColors.ink;
                  }

                  return Semantics(
                      label:
                          'প্রশ্ন ${toBn(idx + 1)}, ${isAnswered ? 'উত্তর দেওয়া' : 'বাকি'}${isReview ? ', রিভিউ চিহ্নিত' : ''}',
                      button: true,
                      selected: isCurrent,
                      child: InkWell(
                        onTap: () {
                          _goToQuestion(idx);
                          Navigator.of(ctx).pop();
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(16),
                            border: border ??
                                (isReview
                                    ? Border.all(
                                        color: PookieColors.accent, width: 2)
                                    : null),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                toBn(idx + 1),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              if (isReview)
                                const Positioned(
                                  top: 2,
                                  right: 2,
                                  child: Icon(Icons.bookmark_rounded,
                                      size: 12, color: PookieColors.accent),
                                ),
                            ],
                          ),
                        ),
                      ));
                }),
              ),
              const SizedBox(height: 16),
              const Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  _LegendItem(
                      color: PookieColors.primary, label: 'উত্তর দেওয়া'),
                  _LegendItem(color: PookieColors.accent, label: 'রিভিউ মার্ক'),
                  _LegendItem(color: PookieColors.blush, label: 'বাকি'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Live mascot pose for the quiz: reacts to progress + time urgency
  MascotPose get _quizMascotPose {
    if (_submitted) return MascotPose.dancing;
    final isUrgent = _secondsRemaining <= 60;
    if (isUrgent) return MascotPose.crying;
    final answered = _chosenAnswers.where((a) => a != null).length;
    final total = widget.questions.length;
    final fraction = answered / total;
    if (fraction == 0) return MascotPose.thinking;
    if (fraction < 0.3) return MascotPose.encourage;
    if (fraction < 0.6) return MascotPose.cheering;
    if (fraction < 1.0) return MascotPose.superHappy;
    return MascotPose.dancing;
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentIndex];
    final isLast = _currentIndex == widget.questions.length - 1;
    final isMarked = _markedForReview.contains(_currentIndex);
    final chosen = _chosenAnswers[_currentIndex];
    final isUrgent = _secondsRemaining <= 60;

    return PopScope(
      canPop: _allowExit,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || _exitDialogOpen || _submitted) return;
        _exitDialogOpen = true;
        final leave = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('কুইজ ছেড়ে দিতে চাও?'),
            content: const Text(
                'এখন বের হয়ে গেলে তোমার বর্তমান অগ্রগতি সংরক্ষিত হবে না।'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('থাকবো')),
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('বেরিয়ে যাই')),
            ],
          ),
        );
        _exitDialogOpen = false;
        if (leave == true && mounted && !_submitted) {
          setState(() => _allowExit = true);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.of(context).pop();
          });
        }
      },
      child: PookieScaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
              tooltip: 'কুইজ বন্ধ করো',
              icon: const Icon(Icons.close_rounded),
              onPressed: () async {
                await Navigator.of(context).maybePop();
              }),
          titleSpacing: 0,
          title: Text(
              'প্রশ্ন ${toBn(_currentIndex + 1)} / ${toBn(widget.questions.length)}',
              style: Theme.of(context).textTheme.titleMedium),
          actions: [
            PulsingBadge(
              enabled: isUrgent,
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                    color:
                        isUrgent ? PookieColors.primaryDeep : PookieColors.blush,
                    borderRadius: BorderRadius.circular(16)),
                child: Semantics(
                    label: 'বাকি সময়',
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.timer_outlined,
                          size: 18,
                          color:
                              isUrgent ? Colors.white : PookieColors.primaryDeep),
                      const SizedBox(width: 6),
                      Text(formatTime(_secondsRemaining),
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: isUrgent
                                  ? Colors.white
                                  : PookieColors.primaryDeep)),
                    ])),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Smooth Animated Progress Bar
            AnimatedProgressBar(
              value: (_currentIndex + 1) / widget.questions.length,
              backgroundColor: PookieColors.blush,
              color: PookieColors.primaryDeep,
              minHeight: 4,
            ),
            Expanded(
              child: ListView(
                controller: _questionScroll,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                children: [
                  // Topic Chip & Action Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: PookieColors.blush,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          getTopicLabel(question.topic),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: PookieColors.primaryDeep,
                          ),
                        ),
                      ),
                      if (question.eventDate != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: PookieColors.accent.withOpacity(0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            ' ${formatIsoDate(question.eventDate)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6A1B9A),
                            ),
                          ),
                        ),
                      ],
                      OutlinedButton.icon(
                        onPressed: _toggleMarkForReview,
                        icon: Icon(
                            isMarked
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline_rounded,
                            size: 18),
                        label: Text(isMarked ? 'রিভিউ চিহ্নিত' : 'রিভিউ মার্ক'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isMarked
                              ? PookieColors.accent
                              : PookieColors.muted,
                          backgroundColor: isMarked
                              ? PookieColors.accent.withOpacity(0.1)
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          minimumSize: const Size(48, 48),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(question.text,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          height: 1.65, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  const Text('একটি উত্তর বেছে নাও',
                      style: TextStyle(color: PookieColors.muted)),
                  const SizedBox(height: 16),
                  // 4 Option Cards
                  for (int i = 0; i < question.options.length; i++) ...[
                    _OptionCard(
                      prefix: bnOptionLetters[i],
                      text: question.options[i],
                      isSelected: chosen == i,
                      onTap: () => _selectOption(i),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
            // Bottom Action Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: BoxDecoration(
                color: PookieColors.surface,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Live mascot in quiz bar
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: LiveMascot(
                      pose: _quizMascotPose,
                      size: 48,
                      interactive: true,
                    ),
                  ),
                  const SizedBox(width: 4),
                  // Palette button
                  IconButton.filledTonal(
                    icon: const Icon(Icons.grid_view_rounded),
                    color: PookieColors.primaryDeep,
                    style: IconButton.styleFrom(
                      backgroundColor: PookieColors.blush,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    tooltip: 'প্রশ্ন প্যালেট',
                    onPressed: _showPalette,
                  ),
                  const SizedBox(width: 8),
                  // Compact previous control leaves room for submit at large text sizes.
                  IconButton.outlined(
                    tooltip: 'পূর্ববর্তী',
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: _currentIndex > 0 ? _previousQuestion : null,
                  ),
                  const Spacer(),
                  // Next or Submit button
                  if (!isLast)
                    PookiePressable(
                      onTap: _nextQuestion,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(110, 48),
                          backgroundColor: PookieColors.primaryDeep,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _nextQuestion,
                        child: const Text('পরবর্তী',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    )
                  else
                    PookiePressable(
                      onTap: _confirmSubmit,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(125, 48),
                          backgroundColor: PookieColors.primaryDeep,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: _confirmSubmit,
                        child: const Text('জমা দাও',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard(
      {required this.prefix,
      required this.text,
      required this.isSelected,
      required this.onTap});
  final String prefix;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = MediaQuery.disableAnimationsOf(context);
    return Semantics(
      button: true,
      selected: isSelected,
      child: PookiePressable(
        onTap: onTap,
        pressedScale: 0.98,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: disabled
              ? Duration.zero
              : const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: isSelected ? PookieColors.blush : PookieColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color:
                    isSelected ? PookieColors.primaryDeep : PookieColors.border,
                width: 1.5),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
                onTap: onTap,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Row(children: [
                    AnimatedScale(
                      scale: isSelected ? 1.08 : 1.0,
                      duration: disabled
                          ? Duration.zero
                          : const Duration(milliseconds: 200),
                      curve: Curves.easeOutBack,
                      child: Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: isSelected
                                ? PookieColors.primaryDeep
                                : PookieColors.blush,
                            borderRadius: BorderRadius.circular(11)),
                        child: Text(prefix,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : PookieColors.ink)),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                        child: Text(text,
                            style: const TextStyle(
                                fontSize: 16,
                                height: 1.55,
                                fontWeight: FontWeight.w500))),
                    if (isSelected) ...[
                      const SizedBox(width: 8),
                      AnimatedScale(
                        scale: 1.0,
                        duration: disabled
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        curve: Curves.easeOutBack,
                        child: const Icon(Icons.check_circle_rounded,
                            color: PookieColors.primaryDeep, size: 22),
                      ),
                    ],
                  ]),
                )),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: PookieColors.ink)),
      ],
    );
  }
}
