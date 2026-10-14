import 'package:flutter/material.dart';

import '../../core/bn.dart';
import '../../core/date_utils.dart';
import '../../core/mascot.dart';
import '../../core/motion.dart';
import '../../core/theme.dart';
import '../../core/page.dart';
import '../../data/models/session_result.dart';
import '../../data/repository/pookie_repository.dart';
import '../bookmarks/bookmarks_screen.dart';
import '../mistakes/mistakes_screen.dart';
import '../news/digest_screen.dart';
import '../progress/progress_screen.dart';
import '../quiz/quiz_screen.dart';
import '../session_setup/session_config.dart';
import '../session_setup/session_setup_screen.dart';
import '../session_setup/topics.dart';
import '../settings/settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.repository,
    required this.onStartPractice,
  });

  final PookieRepository repository;
  final VoidCallback onStartPractice;

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'শুভ সকাল, পুকি!';
    } else if (hour >= 12 && hour < 17) {
      return 'শুভ দুপুর, পুকি!';
    } else if (hour >= 17 && hour < 21) {
      return 'শুভ সন্ধ্যা, পুকি!';
    } else {
      return 'শুভ রাত্রি, পুকি!';
    }
  }

  void _startQuizWithConfig(BuildContext context, SessionConfig config) {
    final questions = repository.buildSessionQuestions(
      topicSlugs: config.topicSlugs,
      count: config.questionCount,
      onlyUnseen: config.onlyUnseen,
      includeMistakes: config.includeMistakes,
      onlyCurrent: config.onlyCurrent,
    );

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('পর্যাপ্ত প্রশ্ন পাওয়া যায়নি')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          questions: questions,
          plannedMinutes: config.minutes,
          topicSlugs: config.topicSlugs,
          repository: repository,
        ),
      ),
    );
  }

  /// Picks a mascot pose based on recent session history.
  MascotPose _homeMascotPose(List<SessionRecord> sessionHistory) {
    if (sessionHistory.isEmpty) return MascotPose.greeting;
    // Use the average accuracy of the last 3 sessions
    final recent = sessionHistory.take(3).toList();
    final avgAcc = recent
            .map((s) => s.accuracy)
            .reduce((a, b) => a + b) /
        recent.length;
    return poseForScore(avgAcc.round());
  }

  String _homeSpeech(MascotPose pose) {
    switch (pose) {
      case MascotPose.dancing:
        return '১০০%! তুমি অসাধারণ! 🎉';
      case MascotPose.superHappy:
        return 'দুর্দান্ত করছো! 🌟';
      case MascotPose.happy:
        return 'ভালো এগোচ্ছো! চালিয়ে যাও!';
      case MascotPose.crying:
        return 'হার মানো না! আবার চেষ্টা করো!';
      case MascotPose.fainted:
        return 'একটু বিশ্রাম নাও, তারপর আবার শুরু!';
      default:
        return 'পুকি তোমার পাশে আছে! 🐾';
    }
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: repository,
        builder: (context, _) {
          final weakTopic = repository.recommendedWeakTopic;
          final mistakes = repository.getMistakeQuestions().length;
          final saved = repository.getBookmarkedQuestions().length;
          final news = repository.digestItems;
          final history = repository.sessionHistory;
          final mascotPose = _homeMascotPose(history);
          void open(Widget page) => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => page));
          return PookieScaffold(
            appBar: AppBar(
              title: const Row(children: [
                Icon(Icons.pets_rounded,
                    color: PookieColors.primaryDeep, size: 25),
                SizedBox(width: 10),
                Text('পুকি প্রেপ'),
              ]),
              actions: [
                IconButton(
                    tooltip: 'সেটিংস',
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () =>
                        open(SettingsScreen(repository: repository))),
                const SizedBox(width: 8)
              ],
            ),
            body: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                children: [
                  Text(formatBnDate(DateTime.now()),
                      style: const TextStyle(
                          color: PookieColors.muted, fontSize: 13)),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                        color: PookieColors.pinkWash,
                        borderRadius: BorderRadius.circular(24)),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(_getTimeGreeting(),
                                          style: const TextStyle(
                                              fontSize: 26,
                                              fontWeight: FontWeight.w600,
                                              height: 1.3)),
                                      const SizedBox(height: 8),
                                      const Text(
                                          'আজ একটু শিখি,\nকাল আরও এগিয়ে যাই।',
                                          style: TextStyle(
                                              fontSize: 16, height: 1.6)),
                                    ])),
                                const SizedBox(width: 8),
                                LiveMascot(
                                  pose: mascotPose,
                                  size: 108,
                                  speechBubble: history.isNotEmpty
                                      ? _homeSpeech(mascotPose)
                                      : null,
                                ),
                              ]),
                          const SizedBox(height: 22),
                          SizedBox(
                              width: double.infinity,
                              child: PookiePressable(
                                  onTap: onStartPractice,
                                  child: FilledButton.icon(
                                      onPressed: onStartPractice,
                                      icon: const Icon(Icons.arrow_forward_rounded),
                                      label: const Text('অনুশীলন শুরু করো')))),
                          const SizedBox(height: 10),
                          const Center(
                              child: Text('বিষয় বেছে নাও · নিজের গতিতে শেখো',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: PookieColors.muted,
                                      fontSize: 13))),
                        ]),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                          color: PookieColors.surface,
                          borderRadius: BorderRadius.circular(16)),
                      child: Wrap(
                          spacing: 20,
                          runSpacing: 14,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            _StudyStat(
                                icon: Icons.local_fire_department_outlined,
                                numericValue: repository.currentStreak,
                                label: 'দিনের স্ট্রিক',
                                color: PookieColors.primaryDeep),
                            _StudyStat(
                                icon: Icons.task_alt_rounded,
                                numericValue: repository.sessionHistory.length,
                                label: 'সম্পূর্ণ সেশন',
                                color: PookieColors.ok),
                            _StudyStat(
                                icon: Icons.bookmark_outline_rounded,
                                numericValue: saved,
                                label: 'সেভ করা প্রশ্ন',
                                color: PookieColors.accent),
                          ])),
                  const SizedBox(height: 28),
                  Text('তোমার পড়ার সঙ্গী',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _StudyLink(
                      icon: Icons.menu_book_rounded,
                      title: 'ভুল থেকেই শেখা',
                      subtitle: mistakes > 0
                          ? '${toBn(mistakes)}টি প্রশ্ন আবার ঝালিয়ে নাও'
                          : 'ভুল হলে এখানে জমবে, আবার শেখার জন্য',
                      color: PookieColors.ok,
                      fill: PookieColors.mint,
                      onTap: () =>
                          open(MistakesScreen(repository: repository))),
                  const SizedBox(height: 10),
                  _StudyLink(
                      icon: Icons.bookmark_rounded,
                      title: 'তোমার সংগ্রহ',
                      subtitle: saved > 0
                          ? '${toBn(saved)}টি সেভ করা প্রশ্ন'
                          : 'পছন্দের প্রশ্ন সেভ করে রাখো',
                      color: PookieColors.accent,
                      fill: PookieColors.lilac,
                      onTap: () =>
                          open(BookmarksScreen(repository: repository))),
                  const SizedBox(height: 10),
                  _StudyLink(
                      icon: Icons.insights_rounded,
                      title: 'একটু একটু এগিয়ে যাওয়া',
                      subtitle: 'কোন বিষয়ে কেমন করছ, দেখে নাও',
                      color: const Color(0xFF94511F),
                      fill: PookieColors.apricot,
                      onTap: () =>
                          open(ProgressScreen(repository: repository))),
                  if (weakTopic != null) ...[
                    const SizedBox(height: 24),
                    _StudyLink(
                        icon: Icons.auto_awesome_rounded,
                        title: '${getTopicLabel(weakTopic)} ঝালিয়ে নাও',
                        subtitle: 'এই বিষয়ে আরেকটু অনুশীলন কাজে আসবে',
                        color: PookieColors.primaryDeep,
                        fill: PookieColors.blush,
                        onTap: () => open(SessionSetupScreen(
                            initialTopicSlugs: [weakTopic],
                            onStart: (config) =>
                                _startQuizWithConfig(context, config)))),
                  ],
                  if (news.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Row(children: [
                      Expanded(
                          child: Text('খবর থেকে শেখা',
                              style: Theme.of(context).textTheme.titleMedium)),
                      TextButton(
                          onPressed: () =>
                              open(DigestScreen(repository: repository)),
                          child: const Text('সবগুলো দেখো'))
                    ]),
                    const SizedBox(height: 8),
                    PookiePressable(
                      onTap: () => open(DigestScreen(repository: repository)),
                      child: Material(
                        color: PookieColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                            onTap: () =>
                                open(DigestScreen(repository: repository)),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        const Icon(Icons.newspaper_outlined,
                                            color: PookieColors.accent,
                                            size: 22),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(
                                                formatIsoDate(news.first.date),
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: PookieColors.muted)))
                                      ]),
                                      const SizedBox(height: 12),
                                      Text(news.first.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      const SizedBox(height: 8),
                                      Text(news.first.fact,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(height: 1.6)),
                                      const SizedBox(height: 14),
                                      const Row(children: [
                                        Text('আরও পড়ো',
                                            style: TextStyle(
                                                color: PookieColors.primaryDeep,
                                                fontWeight: FontWeight.w600)),
                                        SizedBox(width: 6),
                                        Icon(Icons.arrow_forward_rounded,
                                            size: 18,
                                            color: PookieColors.primaryDeep)
                                      ]),
                                    ]))),
                      ),
                    ),
                  ],
                  if (repository.sessionHistory.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    Text('সাম্প্রতিক অনুশীলন',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    for (final rec in repository.sessionHistory.take(3))
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: PookieColors.mint,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: const Icon(Icons.done_rounded,
                                        color: PookieColors.ok)),
                                const SizedBox(width: 14),
                                Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                      Text(
                                          '${formatScore(rec.score)} / ${toBn(rec.plannedCount)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium),
                                      Text(
                                          '${formatBnDate(rec.finishedAt)} · ${toBn(rec.timeTaken.inMinutes)} মিনিট',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: PookieColors.muted)),
                                      Text(
                                          'সঠিক ${toBn(rec.correct)} · ভুল ${toBn(rec.wrong)}',
                                          style: const TextStyle(
                                              fontSize: 13,
                                              color: PookieColors.muted)),
                                    ])),
                              ])),
                  ],
                  const SizedBox(height: 28),
                  const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.offline_pin_outlined,
                            size: 16, color: PookieColors.muted),
                        SizedBox(width: 8),
                        Flexible(
                            child: Text('তোমার প্রস্তুতি, সবসময় তোমার সঙ্গে।',
                                style: TextStyle(
                                    fontSize: 12, color: PookieColors.muted))),
                      ]),
                ]),
          );
        },
      );
}

class _StudyStat extends StatelessWidget {
  const _StudyStat(
      {required this.icon,
      required this.numericValue,
      required this.label,
      required this.color});
  final IconData icon;
  final int numericValue;
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 19, color: color),
          const SizedBox(width: 6),
          AnimatedCountUpText(
            endValue: numericValue,
            style: TextStyle(
                fontSize: 22,
                height: 1.2,
                fontWeight: FontWeight.w600,
                color: color),
          ),
        ]),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: PookieColors.muted)),
      ]);
}

class _StudyLink extends StatelessWidget {
  const _StudyLink(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.color,
      required this.fill,
      required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final Color color, fill;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => PookiePressable(
      onTap: onTap,
      child: Material(
          color: fill,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
              onTap: onTap,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                  child: Row(children: [
                    Icon(icon, color: color, size: 26),
                    const SizedBox(width: 16),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text(title,
                              style: const TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(subtitle,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: PookieColors.muted,
                                  height: 1.5)),
                        ])),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, size: 19, color: color),
                  ])))));
}
