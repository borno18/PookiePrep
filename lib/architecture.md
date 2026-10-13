# Pookie Prep — Architecture

A Bengali-only, light-pink, "pookie" Android app (mascot: a cute white puppy) that helps a Bangladesh medical admission (MAT) student practise General Knowledge: custom quiz sessions, fresh current-affairs questions, and progress tracking.

Status: **decisions locked (Oct 13, 2026)** — see §13 for the decisions log

---

## 1. Goals and non-goals

**Goals**
- Entirely Bengali UI, content and numerals (with an option for English digits).
- Pink, cute, encouraging UI that still feels fast and focused during a timed quiz.
- Build a practice session: **10 / 20 / 30 questions**, **selected topics or all**, **10–20 min timer**.
- Fresh current-affairs questions (national + international) every week, with sources.
- Works **offline** after content is downloaded (mobile data in study spots is unreliable).
- Show weak topics and re-practise mistakes.

**Non-goals (v1)**
- iOS, web, user accounts/login, leaderboards, payments, Play Store release.
- Fully automatic publishing of AI-generated questions (a human reviews first — see §5).

---

## 2. Syllabus → topic taxonomy

Every question has exactly one `topic` and optional `subtopic`.

| Group | Topic (slug) | Bengali label |
|---|---|---|
| Bangladesh | `bd_history` | বাংলাদেশের ইতিহাস |
| | `bd_liberation_war` | মুক্তিযুদ্ধ ও স্বাধীনতা |
| | `bd_geography` | ভূগোল ও পরিবেশ |
| | `bd_economy` | অর্থনীতি ও অবকাঠামো |
| | `bd_constitution` | সংবিধান ও সরকার |
| | `bd_culture_sports` | সংস্কৃতি, ঐতিহ্য ও ক্রীড়া |
| International | `intl_geography` | বিশ্ব ভূগোল |
| | `intl_orgs` | আন্তর্জাতিক সংস্থা |
| | `intl_treaties` | চুক্তি, সম্মেলন ও ঐতিহাসিক ঘটনা |
| | `intl_people_events` | নোবেল, বিশ্বনেতা ও সমসাময়িক ঘটনা |
| Recent | `recent_national` | সাম্প্রতিক (জাতীয়) |
| | `recent_international` | সাম্প্রতিক (আন্তর্জাতিক) |

Question `kind`: `static` (never expires) or `current` (carries `event_date` and an `expires_at` hint, so stale items can be retired).

---

## 3. System overview

```
 ┌────────────────────────────── Content pipeline (runs on your machine / CI) ───────────────────────────┐
 │  RSS / news sources ─► fetch ─► dedupe ─► LLM: extract "GK-worthy facts" ─► LLM: draft Bengali MCQs    │
 │                                                    │                                   │               │
 │                                                    ▼                                   ▼               │
 │                                          facts.json (w/ source URLs)        draft_questions.json       │
 │                                                                                        │               │
 │                                      Review tool (Borno approves / edits / rejects) ◄──┘               │
 │                                                    │                                                   │
 │                                                    ▼                                                   │
 │                       Signed content pack: pack-2026-W42.json  ──► static host (GitHub Pages / R2)     │
 └─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
                                                      │  HTTPS (small JSON, ETag/versioned)
                                                      ▼
 ┌──────────────────────────────────── Android app (Flutter) ─────────────────────────────────────────┐
 │  UI (Bengali, pink)  ─►  Session builder  ─►  Quiz engine (timer, scoring)  ─►  Results/analytics   │
 │                                   │                         │                                        │
 │                                   └──────── Local DB (SQLite via Drift) ◄──────────────────────────┘ │
 │   Pack sync service · Local notifications · Optional cloud backup of progress (v2)                   │
 └───────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

**Key decision: no always-on backend in v1.** Content is produced offline in a pipeline, reviewed, and published as static JSON "packs". The app downloads packs and does everything locally. Benefits: zero hosting cost, no server to maintain, works offline, and — most important — nothing reaches her until a human has checked it.

A FastAPI + PostgreSQL backend only becomes worthwhile if we later add accounts, cross-device sync, or multiple students (see §10).

---

## 4. Android app (Flutter)

**Why Flutter:** you already use it (attendance system), good Bengali text rendering, easy custom theming/animations for the "pookie" feel.

**Suggested packages**
- State: `riverpod`
- Local DB: `drift` (SQLite) — relational queries for "weak topics", "unseen questions"
- Networking: `dio` + `dio_cache_interceptor` (or plain `http` — packs are tiny)
- Localisation: `flutter_localizations` + `intl` (ARB file `app_bn.arb`, Bengali only)
- Notifications: `flutter_local_notifications` (daily reminder, no push server needed)
- Animation: `lottie` / `rive` for mascot, `confetti` for results
- Fonts (bundled, not fetched): **Hind Siliguri** (body), **Baloo Da 2** (cute headings)

**Folder structure (feature-first)**
```
lib/
  core/            theme, l10n, widgets, utils (bn digits, date formatting)
  data/            drift db, repositories, pack_sync, models
  features/
    home/          daily card, streak, shortcuts
    session_setup/ topic picker, count, timer
    quiz/          question view, timer, palette, mark-for-review
    result/        score, explanations, topic breakdown
    mistakes/      mistake notebook + revision quiz
    news/          "এই সপ্তাহের খবর" digest cards (read before quiz)
    bookmarks/
    progress/      charts, weak topics, history
    settings/      digits, reminder time, theme variant
```

---

## 5. Getting the latest news into the app (content pipeline)

This is the hardest part, so it's designed around **accuracy first**.

### 5.1 Sources
- **National:** Prothom Alo, The Daily Star, bdnews24, Samakal, Kaler Kantho, Jugantor, Dhaka Tribune, BSS, plus government sites (Bangladesh Bank, BBS, PMO, Election Commission, Cabinet Division) for official figures/appointments.
- **International:** BBC Bangla, Al Jazeera, Reuters/AP headlines, UN News, WHO news (health angle suits a medical aspirant), nobelprize.org for laureates.
- Prefer **RSS feeds** and official pages. Check each site's terms before scraping.

### 5.2 Copyright-safe approach
Do **not** store or show article text. Store only: extracted **facts** (who/what/when/where/number), the **source name + URL + date**, and **original** question wording. Facts aren't copyrightable; articles are.

### 5.3 Steps
1. **Fetch** (weekly, Sunday night): pull RSS items from the last 7 days.
2. **Dedupe/cluster:** group items about the same event (title similarity / embeddings).
3. **Select GK-worthy events:** LLM scores each cluster with a rubric — national significance, official appointments/awards/records/treaties/summits/Nobel/sports results, "would an exam setter ask this?". Drop crime, gossip, opinion, routine politics.
4. **Extract facts** with sources: structured JSON `{fact, entities, date, sources[]}`.
5. **Draft MCQs** (Claude API) in Bengali: 4 options, one correct answer, a one-line explanation, topic tag, difficulty, `kind=current`. Prompt asks for plausible distractors (same category, e.g. other countries/ministers).
6. **Automated checks:** schema valid; correct option appears in the fact; distractors not duplicates; every question has ≥1 source; Bengali only; no near-duplicate of existing bank.
7. **Human review (required):** a small review UI/CLI shows question + fact + source link; Borno taps Approve / Edit / Reject. ~15 min/week for 30–40 questions.
8. **Publish:** approved items → `pack-YYYY-Www.json` + `manifest.json` (list of packs, versions, SHA-256). Host on GitHub Pages / Cloudflare R2.
9. **App sync:** on launch (Wi-Fi/data), fetch `manifest.json`, download new packs, verify hash, upsert into SQLite.

Automate steps 1–6 with a scheduled GitHub Action (or a local cron job) so only step 7 needs a person.

### 5.3a Month-1 workflow (manual, ChatGPT Plus — no API key)
For the first month the LLM steps (3–5) are done by hand in ChatGPT, so there is no API cost and the pipeline stays simple while we learn what good questions look like:
1. Run `fetch` → script outputs `week-YYYY-Www-items.md` (deduped headlines + source URLs + dates).
2. Paste it into ChatGPT with the saved prompt in `pipeline/prompts/weekly_mcq.md` (rubric, Bengali style guide, exact JSON schema from §8.1).
3. Paste ChatGPT's JSON reply into `pipeline/inbox/week-YYYY-Www.json`.
4. Run `validate` → schema check, correct-answer-in-fact check, duplicate check against the bank.
5. Review (Borno, plus her flags from the previous week) → `publish` builds the pack + manifest.

The pipeline treats "draft questions" as a plain JSON input, so switching to an API later (OpenAI, Claude, or another) only replaces steps 2–3 with a function call. Nothing else changes.

### 5.4 Static question bank
- Bootstrap the `static` bank the same way: feed syllabus topics + trusted references (NCTB textbooks, Banglapedia, constitution text, official stats) into the drafting step, then review.
- Do **not** copy past-paper/coaching-book questions verbatim (copyright). Use them only as style/difficulty references.
- Target for launch: **~600 static questions** (~50 per topic) + the first 2–3 weekly current packs.

### 5.5 Freshness handling
- `current` questions show an "📅 সংবাদের তারিখ" chip and source on the explanation screen.
- Items past `expires_at` (e.g. superseded office-holders) are flagged in the next pack with `retired: true` and disappear from new sessions.
- A *Correction pack* mechanism: if an error is found after publishing, a newer pack overrides that question id.

---

## 6. Features

### 6.1 Session builder (core requirement)
- **Topics:** multi-select chips grouped under বাংলাদেশ / আন্তর্জাতিক / সাম্প্রতিক, or "সব বিষয়".
- **Questions:** 10 / 20 / 30 (segmented buttons).
- **Time:** slider 10–20 min, 1-min steps; default scales with count (e.g., 20 Qs → 15 min).
- Optional toggles: only new questions · include my mistakes · only current affairs.
- Show a gentle hint: "প্রতি প্রশ্নে গড়ে ~৩০ সেকেন্ড" computed from the choices.

**Selection algorithm**
1. Candidate pool = questions in chosen topics, not retired.
2. Weight: unseen ×3, previously wrong ×2.5 (spaced-repetition due), seen-correct recently ×0.3, newest `current` ×1.5.
3. Split count across chosen topics proportionally (min 1 each), fill remainder by weight.
4. Shuffle questions and options (keep correct-option mapping).

### 6.2 Quiz screen
- Countdown ring in the corner (turns softly deeper pink in the last minute), question palette, mark-for-review, skip, previous/next.
- Auto-submit at 0:00; survive app backgrounding (store `deadline_epoch`, not a ticking counter).
- Scoring: +1 correct; **−0.25 per wrong answer (confirmed)**, adjustable in settings; skipped = 0. The count of wrong answers and the marks lost are shown on the result screen.

### 6.3 Results
- Score, accuracy, time used, per-topic bars, confetti/mascot reaction tuned to score (always kind, never shaming).
- Review mode: each question with the right answer, explanation, source (for current ones), bookmark button.

### 6.4 Mistake notebook and revision
- Wrong/skipped questions go to a notebook; "ভুলগুলো আবার" runs a quiz from them.
- Simple spaced repetition (Leitner boxes: review after 1, 3, 7, 14 days).

### 6.5 Weekly digest ("এই সপ্তাহের খবর")
- Swipeable cards of the week's key facts with sources — read first, then "এই সপ্তাহের কুইজ" button.

### 6.6 Progress
- Streak (with a forgiving "freeze" day), topic accuracy radar/bars, last-10-sessions trend, "আজকের দুর্বল বিষয়" suggestion on home.

### 6.7 Extras (nice, later)
- Daily 5-question "মিনি কুইজ" notification at her chosen time.
- Flashcard mode for facts (capitals, organisations, Nobel laureates).
- Share result image as a cute sticker card.
- Mnemonics/trick tips on selected questions.

---

## 7. "Pookie" design system

**Palette (tokens)**
| Token | Hex | Use |
|---|---|---|
| `bg` | `#FFF8FA` | app background (very light pink) |
| `surface` | `#FFFFFF` | cards |
| `blush` | `#FFE8F0` | chips, secondary fills |
| `primary` | `#FF9DBF` | main buttons, active states (light pink; use `ink`/`primaryDeep` text on it, not white) |
| `primaryDeep` | `#D6336C` | text on light, timer low state |
| `accent` | `#B388FF` | small lavender highlights |
| `ok` | `#4CD6A0` | correct (soft mint) |
| `wrong` | `#FF8A80` | wrong (soft coral, not harsh red) |
| `ink` | `#4A2B3A` | body text (warm plum, not black) |

Contrast check required: body text on `bg` and white text on `primary` must pass WCAG AA.

**Shape and feel**
- Large radius (20–28 dp), soft shadows, pill buttons, sticker-style icons.
- Mascot: a cute **white puppy** with 4–5 poses: greeting, thinking (head tilt), cheering, sleepy (late-night), gentle-encourage (paw on shoulder). Vector/Rive so it stays light and animates.
- Micro-animations: bouncy buttons, floating hearts on correct streaks, confetti on results.
- Copy tone: warm, playful Bengali — e.g. "চলো শুরু করি, তুমি পারবে! 🌸", "ভুল হয়েছে? সমস্যা নেই, আবার দেখে নিই 💗".
- **Quiz screen stays calm:** fewer decorations, big readable text — cute shouldn't cost focus.
- Optional dark-plum night theme for late study.

**Bengali specifics**
- Bengali digits by default (০১২৩), setting to switch; format dates like "১৩ অক্টোবর ২০২৬".
- Test long compound letters (যুক্তবর্ণ) for clipping at large font sizes; use generous line-height (~1.5).
- Respect system font scaling up to 1.3×.

---

## 8. Data model

### 8.1 Content pack (JSON)
```json
{
  "pack_id": "2026-W42",
  "version": 1,
  "published_at": "2026-10-18T20:00:00+06:00",
  "questions": [
    {
      "id": "q_cur_20261018_007",
      "kind": "current",
      "topic": "recent_international",
      "subtopic": "nobel",
      "text": "…",
      "options": ["…", "…", "…", "…"],
      "answer_index": 2,
      "explanation": "…",
      "difficulty": 2,
      "event_date": "2026-10-12",
      "expires_at": null,
      "sources": [{"name": "…", "url": "https://…"}],
      "retired": false
    }
  ],
  "digest": [
    {"id": "d_…", "title": "…", "fact": "…", "topic": "…", "date": "…", "sources": []}
  ]
}
```

### 8.2 Local SQLite (Drift)
```
question(id PK, kind, topic, subtopic, text, options_json, answer_index,
         explanation, difficulty, event_date, expires_at, retired, pack_id)
digest_item(id PK, title, fact, topic, date, sources_json, pack_id)
session(id PK, started_at, finished_at, planned_count, planned_minutes,
        topics_json, score, correct, wrong, skipped, neg_mark)
session_answer(session_id FK, question_id FK, chosen_index, time_ms,
               marked_review, is_correct)
question_state(question_id PK, times_seen, times_correct, last_seen,
               leitner_box, next_due, bookmarked)
setting(key PK, value)
pack_sync(pack_id PK, version, sha256, applied_at)
```

---

## 9. Pack hosting and integrity
- `manifest.json` lists packs with `version` and `sha256`; the app downloads only new/changed ones.
- Host on GitHub Pages or Cloudflare R2 (free tier is plenty — packs are tens of KB).
- Verify SHA-256 (v2: sign packs with an Ed25519 key and bundle the public key in the app) so a hijacked URL can't inject questions.
- Ship the app with a bundled **seed pack** so it works on first launch without internet.

---

## 10. When we'd add a backend (v2+)
Triggers: multiple students, cross-device sync, teacher dashboard, remote config.
- **FastAPI + PostgreSQL** (your existing stack), JWT auth, endpoints: `GET /packs`, `POST /sessions`, `GET /me/progress`.
- Review UI becomes a proper admin panel.
- Until then, progress lives on-device with an optional manual "export/import backup" file.

---

## 11. Delivery plan

| Phase | Scope | Output |
|---|---|---|
| 0 | Confirm exam details (§12), pick name/mascot, bank of ~100 seed questions by hand | Spec locked |
| 1 (MVP) | Theme + Bengali l10n, session builder, quiz engine with timer, results, local DB, bundled seed pack | Working APK she can start using |
| 2 | Pack sync, mistake notebook, bookmarks, progress charts | Weekly updates flow |
| 3 | Content pipeline (fetch → draft → review tool → publish) | Weekly current-affairs packs |
| 4 | Digest cards, daily reminder, flashcards, polish, accessibility pass | v1 release |

**Distribution:** sideload APK (or Firebase App Distribution) — no Play Store needed for one student.

---

## 12. Risks and mitigations

| Risk | Mitigation |
|---|---|
| LLM-generated facts are wrong | Mandatory source per question, automated fact-presence check, human review, correction packs |
| Wrong "current" info after events change | `expires_at`, retire flags, show event date on every current question |
| Bengali quality of generated text | Review step; keep a style guide / few-shot examples of good MAT-style Bengali questions |
| Copyright of news/past papers | Store facts + links only; original wording; no verbatim past-paper copying |
| Scope creep (cute extras) | Phase gating; MVP is session builder + quiz + results only |
| Timer drift / backgrounding | Deadline-based timer, not tick-based |
| Weekly review fatigue | Cap packs at ~30–40 questions; automate everything except approval |
| Burnout from streak pressure | Forgiving streak freeze; encouraging, non-shaming copy |

---

## 13. Decisions log and remaining questions

**Decided (Oct 13, 2026)**
- App name: **Pookie Prep**. Mascot: **cute white puppy**. Palette: **lighter pink**.
- Negative marking: **−0.25** per wrong answer.
- Questions are **LLM-generated**, reviewed by Borno; she can flag wrong questions in-app ("ভুল রিপোর্ট" → share sheet with question ID + note).
- Month 1: **manual ChatGPT Plus workflow**, no API key (§5.3a). Revisit automation after the first month.

**Still open**
1. Language of **options**: pure Bengali, or keep English terms for proper nouns/abbreviations (WHO, SAARC)?
2. Does she also want a reviewer mode (approve drafts) later, or is the flag button enough?
6. Past-year question references: does she have a legal source/book you can use as difficulty reference?
7. Single user only, or might classmates use it later (affects backend timing)?
