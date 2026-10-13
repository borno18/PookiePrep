import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pookie_prep/main.dart';
import 'package:pookie_prep/core/theme.dart';
import 'package:pookie_prep/data/models/session_result.dart';
import 'package:pookie_prep/data/repository/pookie_repository.dart';
import 'package:pookie_prep/features/bookmarks/bookmarks_screen.dart';
import 'package:pookie_prep/features/settings/settings_screen.dart';
import 'package:pookie_prep/features/quiz/quiz_screen.dart';
import 'package:pookie_prep/features/result/result_screen.dart';
import 'package:pookie_prep/features/result/review_screen.dart';
import 'package:pookie_prep/features/home/home_screen.dart';
import 'package:pookie_prep/features/mistakes/mistakes_screen.dart';
import 'package:pookie_prep/features/progress/progress_screen.dart';
import 'package:pookie_prep/features/news/digest_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final font = FontLoader('HindSiliguri');
    font.addFont(rootBundle.load('assets/fonts/HindSiliguri-Regular.ttf'));
    font.addFont(rootBundle.load('assets/fonts/HindSiliguri-SemiBold.ttf'));
    await font.load();
    final icons = FontLoader('MaterialIcons')
      ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
    await icons.load();
  });

  Future<PookieRepository> repository() async {
    SharedPreferences.setMockInitialValues({});
    final repo = PookieRepository();
    await repo.init();
    return repo;
  }

  void viewport(WidgetTester tester, Size size) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> capture(WidgetTester tester, String name) async {
    if (!const bool.fromEnvironment('CAPTURE_UI')) return;
    await tester.pump();
    final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(const ValueKey('capture')));
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1.5);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final dir = Directory('.gsd/screenshots')..createSync(recursive: true);
      File('${dir.path}/$name.png')
          .writeAsBytesSync(bytes!.buffer.asUint8List());
      image.dispose();
    });
  }

  Widget captured(Widget child) =>
      RepaintBoundary(key: const ValueKey('capture'), child: child);
  Widget screen(Widget child, {double scale = 1.3}) => captured(MaterialApp(
        theme: buildPookieTheme(),
        debugShowCheckedModeBanner: false,
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(scale), disableAnimations: true),
            child: child!),
        home: child,
      ));

  for (final width in [320.0, 390.0, 1280.0]) {
    testWidgets(
        'all main tabs fit at width $width and preserve practice choices',
        (tester) async {
      viewport(tester, Size(width, 844));
      final repo = await repository();
      await tester.pumpWidget(captured(PookiePrepApp(repository: repo)));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await capture(tester, 'home-${width.toInt()}');
      for (final icon in [
        Icons.play_circle_outline_rounded,
        Icons.menu_book_outlined,
        Icons.newspaper_outlined,
        Icons.bar_chart_rounded
      ]) {
        await tester.tap(find.byIcon(icon).last);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await capture(tester, '${icon.codePoint}-${width.toInt()}');
      }
      await tester.tap(find.byIcon(Icons.play_circle_outline_rounded).last);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilterChip, 'বাংলাদেশের ইতিহাস'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.home_outlined).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.play_circle_outline_rounded).last);
      await tester.pumpAndSettle();
      expect(
          tester
              .widget<FilterChip>(
                  find.widgetWithText(FilterChip, 'বাংলাদেশের ইতিহাস'))
              .selected,
          isTrue);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      repo.dispose();
    });
  }

  testWidgets(
      'quiz answers, review mark, navigation, submit and review work on a small phone',
      (tester) async {
    viewport(tester, const Size(320, 844));
    final repo = await repository();
    final questions = [
      repo.allQuestions.first,
      repo.allQuestions.firstWhere((q) => q.eventDate != null)
    ];
    await tester.pumpWidget(screen(QuizScreen(
        questions: questions,
        plannedMinutes: 10,
        topicSlugs: questions.map((q) => q.topic).toList(),
        repository: repo)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await capture(tester, 'quiz-small');
    await tester.tap(find.text('রিভিউ মার্ক'));
    await tester.pumpAndSettle();
    expect(find.text('রিভিউ চিহ্নিত'), findsOneWidget);
    await tester.ensureVisible(
        find.text(questions.first.options[questions.first.answerIndex]));
    await tester
        .tap(find.text(questions.first.options[questions.first.answerIndex]));
    await tester.tap(find.text('পরবর্তী'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await capture(tester, 'quiz-current-small');
    await tester.tap(find.text('জমা দাও'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(FilledButton, 'জমা দাও')));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(repo.sessionHistory.single.correct, 1);
    expect(repo.sessionHistory.single.skipped, 1);
    expect(repo.sessionHistory.single.answers.first.markedReview, isTrue);
    expect(tester.takeException(), isNull);
    await capture(tester, 'result-small');
    await tester.pumpWidget(const SizedBox());
    repo.dispose();
  });

  testWidgets('30-question palette scrolls on a short screen', (tester) async {
    viewport(tester, const Size(320, 568));
    final repo = await repository();
    await tester.pumpWidget(screen(QuizScreen(
      questions: repo.allQuestions.take(30).toList(),
      plannedMinutes: 10,
      topicSlugs: const [],
      repository: repo,
    )));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await capture(tester, 'palette-small');
    final last = find.text('৩০');
    await tester.ensureVisible(last);
    await tester.tap(last);
    await tester.pumpAndSettle();
    expect(find.text('প্রশ্ন ৩০ / ৩০'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    repo.dispose();
  });

  testWidgets('timer expiry dismisses an open palette and records one result',
      (tester) async {
    viewport(tester, const Size(390, 844));
    final repo = await repository();
    await tester.pumpWidget(screen(QuizScreen(
      questions: repo.allQuestions.take(2).toList(),
      plannedMinutes: 0,
      topicSlugs: const [],
      repository: repo,
    )));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(ResultScreen), findsOneWidget);
    expect(find.byType(QuizScreen), findsNothing);
    expect(find.text('প্রশ্ন প্যালেট'), findsNothing);
    expect(repo.sessionHistory.length, 1);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    repo.dispose();
  });

  testWidgets('quiz exit confirms once and leaves the route', (tester) async {
    viewport(tester, const Size(390, 844));
    final repo = await repository();
    await tester.pumpWidget(screen(Builder(
        builder: (context) => Scaffold(
                body: TextButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => QuizScreen(
                      questions: repo.allQuestions.take(2).toList(),
                      plannedMinutes: 10,
                      topicSlugs: const [],
                      repository: repo))),
              child: const Text('open'),
            )))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('বেরিয়ে যাই'));
    await tester.pumpAndSettle();
    expect(find.byType(QuizScreen), findsNothing);
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('open'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    repo.dispose();
  });

  testWidgets('collections, settings and review fit with larger Bengali text',
      (tester) async {
    viewport(tester, const Size(320, 844));
    final repo = await repository();
    final questions = repo.allQuestions.take(3).toList();
    await repo.toggleBookmark(questions.first.id);
    final session = SessionRecord(
      id: 'ui-session',
      startedAt: DateTime(2026, 10, 13, 10),
      finishedAt: DateTime(2026, 10, 13, 10, 5),
      plannedCount: 3,
      plannedMinutes: 10,
      topicSlugs: questions.map((q) => q.topic).toList(),
      score: 0.75,
      correct: 1,
      wrong: 1,
      skipped: 1,
      marksLost: 0.25,
      answers: [
        SessionAnswerRecord(
            questionId: questions[0].id,
            chosenIndex: questions[0].answerIndex,
            isCorrect: true),
        SessionAnswerRecord(
            questionId: questions[1].id,
            chosenIndex: (questions[1].answerIndex + 1) % 4,
            isCorrect: false),
        SessionAnswerRecord(
            questionId: questions[2].id, chosenIndex: null, isCorrect: false),
      ],
    );
    await repo.recordSession(session);
    final screens = <String, Widget>{
      'home-populated': HomeScreen(repository: repo, onStartPractice: () {}),
      'mistakes-populated': MistakesScreen(repository: repo),
      'progress-populated': ProgressScreen(repository: repo),
      'news': DigestScreen(repository: repo),
      'bookmarks': BookmarksScreen(repository: repo),
      'settings': SettingsScreen(repository: repo),
      'review': ReviewScreen(
          session: session, questions: questions, repository: repo),
      'result-populated': ResultScreen(
          session: session, questions: questions, repository: repo),
    };
    for (final entry in screens.entries) {
      await tester.pumpWidget(screen(entry.value));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: entry.key);
      await capture(tester, '${entry.key}-small');
      for (var i = 0; i < 3; i++) {
        await tester.drag(find.byType(ListView).first, const Offset(0, -500));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '${entry.key} scrolled');
      }
      if (entry.key == 'news') {
        await tester.scrollUntilVisible(find.text('খবরের কুইজ দাও'), 500);
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      }
      await capture(tester, '${entry.key}-scrolled-small');
      await tester.pumpWidget(const SizedBox());
    }
    repo.dispose();
  });
}
