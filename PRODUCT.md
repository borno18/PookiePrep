# Product

<!-- impeccable:product-schema 1 -->

## Platform

android

## Users

**Primary — Student:** Bangladesh Medical Admission Test (MAT) aspirant. Studies solo on their personal Android device, often in environments with unreliable mobile data (coaching centres, home). Needs encouragement and focus during timed practice. Bengali is the only comfortable language.

**Secondary — Content Manager (Teacher/Tutor):** Reviews and approves drafted MCQs before they are packaged into content packs. Works on a desktop machine outside the app itself, using the content pipeline tools.

## Product Purpose

Pookie Prep helps a Bangladesh MAT student build General Knowledge confidence through personalised, timed MCQ practice — covering the full 12-topic syllabus, fresh current-affairs questions updated weekly, and mistake-driven spaced repetition. Success means the student walks into the exam feeling prepared and unhurried.

## Positioning

The only Bengali-first, medically-focused GK practice app that combines: a curated offline content pipeline (human-reviewed before delivery), Leitner-box spaced repetition, and a non-shaming, mascot-guided experience designed specifically for Bangladesh MAT syllabus coverage — not a general quiz tool adapted for the exam.

## Operating Context

- Practice happens **offline after initial content download**; mobile data is unreliable in typical study environments.
- Sessions are **timed** (10–20 min) with 10 / 20 / 30 question counts.
- Students reference **12 GK topic groups** across Bangladesh, International, and Recent Affairs.
- Content is refreshed **weekly** via a signed content pack pipeline (RSS → LLM draft → human review → pack hosted on GitHub Pages / R2).
- The teacher/tutor uses the **review tool** (outside the app) to approve, edit, or reject drafted questions before the pack is signed.
- **Negative marking:** +1 correct, −0.25 wrong, 0 skipped — matching the real MAT scheme.

## Capabilities and Constraints

- **Platform:** Android only (v1). iOS, web, user accounts, leaderboards, and payments are explicitly out of scope for v1.
- **Stack:** Flutter (Dart), `shared_preferences` for local persistence, `HindSiliguri` font family bundled.
- **Language:** Bengali-only UI and content; Bengali numeral display with an optional English-digit toggle.
- **Offline-first:** all practice data (questions, progress, mistakes) lives on device; content packs downloaded on demand.
- **AI-generated questions require human approval** before shipping; no fully-automatic publishing.
- **Distribution target:** Android Play Store (future public release for Bangladesh MAT aspirants).
- **Testing standard:** `flutter analyze .` (0 errors/warnings), `flutter test` passing.

## Brand Commitments

- **Name:** Pookie Prep (পুকি প্রেপ).
- **Mascot:** Cute white puppy with 5 expressive poses (Greeting, Thinking, Cheering, Sleepy, Encouraging).
- **Aesthetic:** Light pink (`#FFF8FA` bg, `#FF9DBF` primary, `#D6336C` deep accent) — the pink and puppy are non-negotiable identity anchors.
- **Voice:** Kind, non-shaming, encouraging. Bengali throughout. Mascot reactions are tuned to student score to never demotivate.

## Evidence on Hand

- **Source dataset:** `DataSets/v1newdata.json` — 300 verified MCQs covering 4 topic areas (latest international news, FIFA World Cup 2026, July Revolution of Bangladesh 2024, BNP and Ziaur Rahman history).
- **Architecture:** `architecture.md` — locked decisions as of Oct 13, 2026.
- **Codebase:** Full Flutter app in `lib/`; features built include quiz engine, result/review engine, mistake notebook (Leitner), weekly news digest, bookmarks, and progress analytics.
- **No testimonials, press, or benchmark data on hand.**

## Product Principles

1. **Bengali first, always.** Every string, numeral, and error message lives in Bengali; English is never a fallback visible to the student.
2. **Offline is the baseline.** The app must be fully functional after content download; network absence is the expected state, not an error state.
3. **Kindness over competition.** No shame, no peer comparison. Feedback is mascot-guided and encourages re-practice, not judgment.
4. **Exam-accurate feedback.** The negative-marking scheme, topic taxonomy, and difficulty distribution must match the real MAT — not simplified for comfort.
5. **Human-gated content quality.** No AI-drafted question reaches the student without teacher review and a signed content pack.

## Accessibility & Inclusion

- WCAG AA contrast maintained across the pink palette (confirmed in design spec).
- Bengali numeral toggle for students more comfortable with Western digits.
- Mascot pose system provides visual, non-text emotional cues alongside written feedback.
