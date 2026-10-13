import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/bn.dart';
import '../core/date_utils.dart';
import '../data/models/session_result.dart';
import '../data/repository/pookie_repository.dart';
import '../features/quiz/scoring.dart';
import '../features/session_setup/topics.dart';

void main() {
  group('Bengali digit and date formatting', () {
    test('converts numbers to Bengali digits', () {
      expect(toBn(0), '০');
      expect(toBn(12345), '১২৩৪৫');
      expect(toBn(2026), '২০২৬');
    });

    test('formats score correctly', () {
      expect(formatScore(15.0), '১৫');
      expect(formatScore(14.75), '১৪.৭৫');
      expect(formatScore(-0.25), '-০.২৫');
    });

    test('formats time mm:ss in Bengali', () {
      expect(formatTime(90), '০১:৩০');
      expect(formatTime(0), '০০:০০');
      expect(formatTime(600), '১০:০০');
    });

    test('formats Bengali date', () {
      final date = DateTime(2026, 10, 13);
      expect(formatBnDate(date), '১৩ অক্টোবর ২০২৬');
    });
  });

  group('Scoring engine (architecture.md §6.2)', () {
    test('calculates correct, wrong, skipped and -0.25 negative marks', () {
      // 4 questions: 2 correct, 1 wrong, 1 skipped
      final result = scoreSession(
        chosen: [1, 2, 0, null],
        answers: [1, 2, 3, 0],
        negativeMark: 0.25,
      );

      expect(result.correct, 2);
      expect(result.wrong, 1);
      expect(result.skipped, 1);
      expect(result.marksLost, 0.25);
      expect(result.score, 1.75); // 2 - 0.25 = 1.75
    });

    test('all correct gives full score', () {
      final result = scoreSession(
        chosen: [0, 1, 2],
        answers: [0, 1, 2],
      );
      expect(result.score, 3.0);
      expect(result.marksLost, 0.0);
    });
  });

  group('Taxonomy (architecture.md §2)', () {
    test('all 12 topics are defined across 3 groups', () {
      expect(allTopicSlugs.length, 12);
      expect(topicGroups.length, 3);
      expect(topicGroups[0].label, 'বাংলাদেশ');
      expect(topicGroups[1].label, 'আন্তর্জাতিক');
      expect(topicGroups[2].label, 'সাম্প্রতিক');
      expect(getTopicLabel('bd_liberation_war'), 'মুক্তিযুদ্ধ ও স্বাধীনতা');
    });
  });

  group('Repository, Seed Pack & Mistake Notebook', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('bootstraps seed questions and digests on init', () async {
      final repo = PookieRepository();
      await repo.init();

      expect(repo.allQuestions.length, greaterThanOrEqualTo(20));
      expect(repo.digestItems.length, greaterThanOrEqualTo(3));
      expect(repo.allQuestions.any((q) => q.topic == 'bd_liberation_war'), isTrue);
      expect(repo.allQuestions.any((q) => q.isCurrent), isTrue);
    });

    test('tracks mistakes, Leitner boxes, and bookmarks', () async {
      final repo = PookieRepository();
      await repo.init();

      final firstQ = repo.allQuestions.first;
      expect(repo.getQuestionState(firstQ.id).bookmarked, isFalse);

      await repo.toggleBookmark(firstQ.id);
      expect(repo.getQuestionState(firstQ.id).bookmarked, isTrue);
      expect(repo.getBookmarkedQuestions().map((q) => q.id), contains(firstQ.id));

      // Record a session with 1 correct, 1 wrong
      final q2 = repo.allQuestions[1];
      final record = SessionRecord(
        id: 'test_session_1',
        startedAt: DateTime.now().subtract(const Duration(minutes: 5)),
        finishedAt: DateTime.now(),
        plannedCount: 2,
        plannedMinutes: 5,
        topicSlugs: [firstQ.topic, q2.topic],
        score: 0.75,
        correct: 1,
        wrong: 1,
        skipped: 0,
        marksLost: 0.25,
        answers: [
          SessionAnswerRecord(questionId: firstQ.id, chosenIndex: firstQ.answerIndex, isCorrect: true),
          SessionAnswerRecord(questionId: q2.id, chosenIndex: (q2.answerIndex + 1) % 4, isCorrect: false),
        ],
      );

      await repo.recordSession(record);

      // firstQ was correct -> Leitner box increments to 2
      expect(repo.getQuestionState(firstQ.id).leitnerBox, 2);
      expect(repo.getQuestionState(firstQ.id).isMistake, isFalse);

      // q2 was wrong -> Leitner box is 1, marked as mistake
      expect(repo.getQuestionState(q2.id).leitnerBox, 1);
      expect(repo.getQuestionState(q2.id).isMistake, isTrue);

      final mistakes = repo.getMistakeQuestions();
      expect(mistakes.map((q) => q.id), contains(q2.id));
      expect(repo.recommendedWeakTopic, q2.topic);
    });

    test('session builder respects topic filters and count', () async {
      final repo = PookieRepository();
      await repo.init();

      final sessionQuestions = repo.buildSessionQuestions(
        topicSlugs: ['bd_liberation_war', 'bd_history'],
        count: 10,
      );

      expect(sessionQuestions.length, lessThanOrEqualTo(10));
      for (final q in sessionQuestions) {
        expect(['bd_liberation_war', 'bd_history'].contains(q.topic), isTrue);
      }
    });
  });
}
