# Pookie Prep (পুকি প্রেপ) 🌸🐶

A Bengali-only, light-pink, "pookie" Flutter application (mascot: a cute white puppy) designed to help a Bangladesh Medical Admission Test (MAT) aspirant practice General Knowledge with confidence and joy.

Built strictly according to [`architecture.md`](file:///c:/Users/joydi/Downloads/pookie_prep/pookie_prep/lib/architecture.md).

---

## 🌟 Built Features

### 1. "Pookie" Design System & Mascot (`lib/core/`)
- **Pink Aesthetic:** `#FFF8FA` background, `#FFFFFF` rounded cards, `#FFE8F0` blush chips, `#FF9DBF` primary buttons, `#D6336C` deep text/accents, and WCAG AA contrast.
- **Cute White Puppy Mascot (`PookieMascot`):** Vector-drawn interactive puppy with 5 expressive poses:
  - 🌸 **Greeting:** Happy puppy waving with blossom
  - ❓ **Thinking:** Curious head tilt with question mark
  - 🎉 **Cheering:** Joyful celebration with floating sparkles
  - 💤 **Sleepy:** Snoozing puppy with Zzz bubbles
  - 💗 **Encouraging:** Outstretched paw ("তুমি পারবে!")
- **Bengali Numerals & Dates (`toBn`, `formatBnDate`):** Full Bengali digits (`০১২৩৪৫৬৭৮৯`) with toggles, timer formatting, and score displays.
- **Confetti Celebration (`PookieConfetti`):** Heart & ribbon particles on high score results.

### 2. Syllabus & Topic Taxonomy (`lib/features/session_setup/topics.dart`)
Fully models the 12 medical admission GK topics across 3 main groups:
- **বাংলাদেশ:** ইতিহাস, মুক্তিযুদ্ধ ও স্বাধীনতা, ভূগোল ও পরিবেশ, অর্থনীতি ও অবকাঠামো, সংবিধান ও সরকার, সংস্কৃতি ঐতিহ্য ও ক্রীড়া.
- **আন্তর্জাতিক:** বিশ্ব ভূগোল, আন্তর্জাতিক সংস্থা, চুক্তি ও সম্মেলন, নোবেল ও বিশ্বনেতা.
- **সাম্প্রতিক:** সাম্প্রতিক (জাতীয়), সাম্প্রতিক (আন্তর্জাতিক).

### 3. Practice Session Builder (`lib/features/session_setup/`)
- Choose all topics or specific multi-select chips.
- 10 / 20 / 30 questions segmented buttons.
- 10–20 minute timer slider with real-time pace hints ("প্রতি প্রশ্নে গড়ে ~৩০ সেকেন্ড").
- Filter toggles:
  - "শুধু নতুন প্রশ্ন" (unseen questions only)
  - "আমার ভুলগুলো অগ্রাধিকার দাও" (include past mistakes)
  - "শুধু সাম্প্রতিক ঘটনা" (current affairs only)

### 4. Quiz Engine (`lib/features/quiz/`)
- **Deadline-based countdown timer:** Survives app backgrounding and accurately counts down to 0:00.
- Soft deep-pink pulsing countdown ring in the last 60 seconds.
- Interactive **Question Palette Sheet** with color-coded status (Answered, Marked for Review, Remaining).
- **Mark for Review (🔖)** flag per question.
- Bengali option cards (ক, খ, গ, ঘ) with tactile selection states.
- Confirmation dialog before submit showing answered vs remaining questions.
- Auto-submit when the timer expires.

### 5. Results & Review Engine (`lib/features/result/`)
- **Marking Scheme:** +1 correct, **−0.25 negative mark** per wrong answer, 0 for skipped.
- Detailed score breakdown, accuracy percentage, time used, and marks lost.
- Kind, non-shaming mascot reactions tuned to student's score.
- Per-topic progress bars.
- **One-tap retry:** "ভুলগুলো আবার প্র্যাকটিস করো 🔄" instantly generates a revision quiz of the mistakes made in that session.
- **Detailed Review Mode (`ReviewScreen`):**
  - Shows chosen option vs correct answer with explanations.
  - Source attribution chips (e.g. `📅 সংবাদের তারিখ`, `উৎস: প্রথম আলো`).
  - Question error reporting dialog ("ভুল রিপোর্ট").
  - Instant bookmark toggle.

### 6. Mistake Notebook ("ভুল খাতা") (`lib/features/mistakes/`)
- Automatically records questions answered incorrectly or skipped.
- Implements **Leitner box** spaced repetition (boxes 1 to 5).
- Filter mistakes by topic.
- Dedicated "ভুলগুলো আবার প্র্যাকটিস" revision quiz launcher.

### 7. Weekly News Digest ("এই সপ্তাহের খবর") (`lib/features/news/`)
- Swipeable cards of the week's key GK facts with dates and source URLs.
- "এই সপ্তাহের খবরের ওপর কুইজ দাও 🚀" button to practice current affairs directly.

### 8. Bookmarks & Progress Analytics (`lib/features/bookmarks/`, `lib/features/progress/`)
- Saved questions list with explanation review.
- Consecutive practice streak counter (🔥).
- Automatic **Weak Topic Detection** ("আজকের দুর্বল বিষয়") suggesting targeted practice.
- Topic-wise accuracy breakdown and historical session logs.

### 9. Offline Seed Pack & Repository (`lib/data/`)
- Bundled seed pack with 30+ verified medical admission GK questions across all 12 syllabus topics.
- Persistent local storage with `SharedPreferences` and clean repository pattern.

---

## 🧪 Testing & Validation

```bash
flutter analyze .   # Verified: 0 errors, 0 warnings
flutter test test/pookie_prep_test.dart  # 10/10 tests passed!
```
