import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../core/mascot.dart';
import '../../data/repository/pookie_repository.dart';
import '../home/home_screen.dart';
import '../mistakes/mistakes_screen.dart';
import '../news/digest_screen.dart';
import '../progress/progress_screen.dart';
import '../quiz/quiz_screen.dart';
import '../session_setup/session_config.dart';
import '../session_setup/session_setup_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key, required this.repository});
  final PookieRepository repository;
  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _stackKey = GlobalKey();
  void _selectTab(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
  }

  void _startQuiz(SessionConfig config) {
    final questions = widget.repository.buildSessionQuestions(
      topicSlugs: config.topicSlugs,
      count: config.questionCount,
      onlyUnseen: config.onlyUnseen,
      includeMistakes: config.includeMistakes,
      onlyCurrent: config.onlyCurrent,
    );
    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('পর্যাপ্ত প্রশ্ন পাওয়া যায়নি 🌸')));
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => QuizScreen(
              questions: questions,
              plannedMinutes: config.minutes,
              topicSlugs: config.topicSlugs,
              repository: widget.repository,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen(
          repository: widget.repository, onStartPractice: () => _selectTab(1)),
      SessionSetupScreen(onStart: _startQuiz),
      MistakesScreen(repository: widget.repository),
      DigestScreen(repository: widget.repository),
      ProgressScreen(repository: widget.repository),
    ];
    const labels = ['হোম', 'অনুশীলন', 'ভুল খাতা', 'সংবাদ', 'অগ্রগতি'];
    const icons = [
      Icons.home_outlined,
      Icons.play_circle_outline_rounded,
      Icons.menu_book_outlined,
      Icons.newspaper_outlined,
      Icons.bar_chart_rounded
    ];
    const active = [
      Icons.home_rounded,
      Icons.play_circle_fill_rounded,
      Icons.menu_book_rounded,
      Icons.newspaper_rounded,
      Icons.insights_rounded
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 760;
      final content = IndexedStack(
        key: _stackKey,
        index: _currentIndex,
        children: [
          for (var i = 0; i < pages.length; i++)
            TickerMode(enabled: i == _currentIndex, child: pages[i])
        ],
      );
      return Scaffold(
        body: Row(children: [
          if (wide) ...[
            SafeArea(
                child: NavigationRail(
              extended: constraints.maxWidth >= 1100,
              minExtendedWidth: 204,
              selectedIndex: _currentIndex,
              onDestinationSelected: _selectTab,
              labelType: constraints.maxWidth >= 1100
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: PookieMascot(size: 64)),
              destinations: [
                for (var i = 0; i < labels.length; i++)
                  NavigationRailDestination(
                      icon: Icon(icons[i]),
                      selectedIcon: Icon(active[i]),
                      label: Text(labels[i]))
              ],
            )),
            const VerticalDivider(width: 1),
          ],
          Expanded(child: content),
        ]),
        bottomNavigationBar: wide
            ? null
            : DecoratedBox(
                decoration: const BoxDecoration(
                    border:
                        Border(top: BorderSide(color: PookieColors.border))),
                child: NavigationBar(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: _selectTab,
                  destinations: [
                    for (var i = 0; i < labels.length; i++)
                      NavigationDestination(
                          icon: Icon(icons[i]),
                          selectedIcon:
                              Icon(active[i], color: PookieColors.primaryDeep),
                          label: labels[i])
                  ],
                ),
              ),
      );
    });
  }
}
