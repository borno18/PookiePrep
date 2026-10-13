import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/digest_item.dart';
import '../models/question.dart';
import '../models/question_state.dart';
import '../models/session_result.dart';
import '../models/user_settings.dart';
import '../seed/seed_pack.dart';
import '../../features/session_setup/topics.dart';

class PookieRepository extends ChangeNotifier {
  PookieRepository({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  final Map<String, Question> _questions = {};
  final List<DigestItem> _digestItems = [];
  final Map<String, QuestionState> _questionStates = {};
  final List<SessionRecord> _sessionHistory = [];
  UserSettings _settings = const UserSettings();

  bool _initialized = false;
  bool get isInitialized => _initialized;

  List<Question> get allQuestions => _questions.values.toList();
  List<DigestItem> get digestItems => List.unmodifiable(_digestItems);
  List<SessionRecord> get sessionHistory => List.unmodifiable(_sessionHistory);
  UserSettings get settings => _settings;

  /// Initializes storage and loads seed data if first launch.
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();

    // 1. Load settings
    final settingsJson = _prefs!.getString('pookie_settings');
    if (settingsJson != null) {
      try {
        _settings = UserSettings.fromJson(jsonDecode(settingsJson) as Map<String, dynamic>);
      } catch (_) {}
    }

    // 2. Load questions
    final questionsJson = _prefs!.getString('pookie_questions');
    if (questionsJson != null) {
      try {
        final list = (jsonDecode(questionsJson) as List<dynamic>)
            .map((e) => Question.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final q in list) {
          _questions[q.id] = q;
        }
      } catch (_) {}
    }
    // Always upsert seed questions that are not yet in storage
    var addedNewSeed = false;
    for (final q in SeedPack.questions) {
      if (!_questions.containsKey(q.id)) {
        _questions[q.id] = q;
        addedNewSeed = true;
      }
    }
    if (addedNewSeed) {
      await _persistQuestions();
    }

    // 3. Load digest items
    final digestJson = _prefs!.getString('pookie_digests');
    if (digestJson != null) {
      try {
        final list = (jsonDecode(digestJson) as List<dynamic>)
            .map((e) => DigestItem.fromJson(e as Map<String, dynamic>))
            .toList();
        _digestItems.addAll(list);
      } catch (_) {}
    }
    if (_digestItems.isEmpty) {
      _digestItems.addAll(SeedPack.digestItems);
      await _persistDigests();
    }

    // 4. Load question states (bookmarks, mistakes, Leitner box)
    final statesJson = _prefs!.getString('pookie_question_states');
    if (statesJson != null) {
      try {
        final map = (jsonDecode(statesJson) as Map<String, dynamic>).map(
          (k, v) => MapEntry(k, QuestionState.fromJson(v as Map<String, dynamic>)),
        );
        _questionStates.addAll(map);
      } catch (_) {}
    }

    // 5. Load session history
    final historyJson = _prefs!.getString('pookie_history');
    if (historyJson != null) {
      try {
        final list = (jsonDecode(historyJson) as List<dynamic>)
            .map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
            .toList();
        _sessionHistory.addAll(list);
      } catch (_) {}
    }

    _initialized = true;
    notifyListeners();
  }

  // --- Persistence Helpers ---

  Future<void> _persistQuestions() async {
    if (_prefs == null) return;
    final list = _questions.values.map((q) => q.toJson()).toList();
    await _prefs!.setString('pookie_questions', jsonEncode(list));
  }

  Future<void> _persistDigests() async {
    if (_prefs == null) return;
    final list = _digestItems.map((d) => d.toJson()).toList();
    await _prefs!.setString('pookie_digests', jsonEncode(list));
  }

  Future<void> _persistQuestionStates() async {
    if (_prefs == null) return;
    final map = _questionStates.map((k, v) => MapEntry(k, v.toJson()));
    await _prefs!.setString('pookie_question_states', jsonEncode(map));
  }

  Future<void> _persistHistory() async {
    if (_prefs == null) return;
    final list = _sessionHistory.map((s) => s.toJson()).toList();
    await _prefs!.setString('pookie_history', jsonEncode(list));
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    _settings = newSettings;
    if (_prefs != null) {
      await _prefs!.setString('pookie_settings', jsonEncode(_settings.toJson()));
    }
    notifyListeners();
  }

  // --- Bookmark & State Actions ---

  QuestionState getQuestionState(String questionId) {
    return _questionStates[questionId] ?? QuestionState(questionId: questionId);
  }

  Future<void> toggleBookmark(String questionId) async {
    final cur = getQuestionState(questionId);
    _questionStates[questionId] = cur.copyWith(bookmarked: !cur.bookmarked);
    await _persistQuestionStates();
    notifyListeners();
  }

  List<Question> getBookmarkedQuestions() {
    return _questions.values
        .where((q) => _questionStates[q.id]?.bookmarked == true)
        .toList();
  }

  List<Question> getMistakeQuestions({String? topicSlug}) {
    return _questions.values.where((q) {
      if (topicSlug != null && q.topic != topicSlug) return false;
      final state = _questionStates[q.id];
      return state != null && state.isMistake;
    }).toList();
  }

  // --- Session Builder Algorithm (architecture.md §6.1) ---

  List<Question> buildSessionQuestions({
    required List<String> topicSlugs,
    required int count,
    bool onlyUnseen = false,
    bool includeMistakes = false,
    bool onlyCurrent = false,
  }) {
    final random = Random();

    // 1. Candidate pool: chosen topics, not retired
    var candidates = _questions.values.where((q) {
      if (q.retired) return false;
      if (!topicSlugs.contains(q.topic)) return false;
      if (onlyCurrent && !q.isCurrent) return false;

      final state = _questionStates[q.id];
      if (onlyUnseen && state != null && state.timesSeen > 0) return false;
      if (includeMistakes && (state == null || !state.isMistake)) {
        // Still allow if we need pool, but priority to mistakes
      }
      return true;
    }).toList();

    if (candidates.isEmpty) {
      // Fallback to any questions in chosen topics
      candidates = _questions.values.where((q) => topicSlugs.contains(q.topic)).toList();
    }
    if (candidates.isEmpty) {
      candidates = _questions.values.toList();
    }

    // 2. Weighting formula:
    // unseen x3, previously wrong x2.5, seen-correct recently x0.3, newest current x1.5
    final weighted = <Question, double>{};
    for (final q in candidates) {
      final state = _questionStates[q.id];
      double weight = 1.0;
      if (state == null || state.timesSeen == 0) {
        weight *= 3.0;
      } else if (state.isMistake) {
        weight *= 2.5;
      } else if (state.timesCorrect > 0) {
        weight *= 0.3;
      }
      if (q.isCurrent) {
        weight *= 1.5;
      }
      weighted[q] = weight + random.nextDouble() * 0.1; // jitter
    }

    // 3. Proportional topic coverage (ensure min 1 from each selected topic if available)
    final selectedQuestions = <Question>{};
    for (final slug in topicSlugs) {
      final topicCandidates = candidates.where((q) => q.topic == slug).toList();
      if (topicCandidates.isNotEmpty) {
        topicCandidates.sort((a, b) => (weighted[b] ?? 1.0).compareTo(weighted[a] ?? 1.0));
        selectedQuestions.add(topicCandidates.first);
      }
      if (selectedQuestions.length >= count) break;
    }

    // Fill remaining spots by weight
    final sortedCandidates = candidates.toList()
      ..sort((a, b) => (weighted[b] ?? 1.0).compareTo(weighted[a] ?? 1.0));

    for (final q in sortedCandidates) {
      if (selectedQuestions.length >= count) break;
      selectedQuestions.add(q);
    }

    // If still less than requested count (small pool), allow cycling or taking all
    final finalResult = selectedQuestions.toList()..shuffle(random);
    return finalResult.take(count).toList();
  }

  // --- Record Session Results & Spaced Repetition (§6.2, §6.3, §6.4) ---

  Future<void> recordSession(SessionRecord record) async {
    _sessionHistory.insert(0, record);

    final now = DateTime.now();

    for (final ans in record.answers) {
      final current = getQuestionState(ans.questionId);
      final timesSeen = current.timesSeen + 1;
      final timesCorrect = current.timesCorrect + (ans.isCorrect ? 1 : 0);
      final isMistake = !ans.isCorrect;

      // Leitner box calculation
      int box = current.leitnerBox;
      if (ans.isCorrect) {
        box = (box + 1).clamp(1, 5);
      } else {
        box = 1; // reset on wrong answer
      }

      _questionStates[ans.questionId] = current.copyWith(
        timesSeen: timesSeen,
        timesCorrect: timesCorrect,
        lastSeen: now,
        leitnerBox: box,
        isMistake: isMistake,
      );
    }

    await _persistHistory();
    await _persistQuestionStates();
    notifyListeners();
  }

  // --- Analytics & Insights (§6.6) ---

  /// Calculates consecutive practice streak in days.
  int get currentStreak {
    if (_sessionHistory.isEmpty) return 0;

    final sortedDates = _sessionHistory
        .map((s) => DateTime(s.finishedAt.year, s.finishedAt.month, s.finishedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    if (sortedDates.isEmpty) return 0;
    if (sortedDates.first != todayDate && sortedDates.first != yesterdayDate) {
      return 0; // streak broken
    }

    int streak = 1;
    for (int i = 0; i < sortedDates.length - 1; i++) {
      final diff = sortedDates[i].difference(sortedDates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  /// Weak topic recommendation for home screen: topic with lowest accuracy or highest mistake count.
  String? get recommendedWeakTopic {
    final mistakes = getMistakeQuestions();
    if (mistakes.isNotEmpty) {
      final counts = <String, int>{};
      for (final m in mistakes) {
        counts[m.topic] = (counts[m.topic] ?? 0) + 1;
      }
      final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
      return sorted.first.key;
    }
    return null;
  }

  /// Calculates accuracy per topic slug.
  Map<String, double> get topicAccuracy {
    final attempts = <String, int>{};
    final corrects = <String, int>{};

    for (final session in _sessionHistory) {
      for (final ans in session.answers) {
        final q = _questions[ans.questionId];
        if (q != null) {
          attempts[q.topic] = (attempts[q.topic] ?? 0) + 1;
          if (ans.isCorrect) {
            corrects[q.topic] = (corrects[q.topic] ?? 0) + 1;
          }
        }
      }
    }

    final result = <String, double>{};
    for (final slug in allTopicSlugs) {
      final total = attempts[slug] ?? 0;
      final ok = corrects[slug] ?? 0;
      result[slug] = total > 0 ? (ok / total) * 100 : 0.0;
    }
    return result;
  }
}
