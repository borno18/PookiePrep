---
name: Pookie Prep
description: A playful Bengali study companion with pink warmth and quiet reading surfaces.
colors:
  bg: "#FFF8FA"
  surface: "#FFFFFF"
  blush: "#FCE5EE"
  primary: "#FF9DBF"
  primary-deep: "#D6336C"
  accent: "#7050A0"
  mint: "#E6F4EE"
  lilac: "#F0E9FA"
  apricot: "#FFEEDF"
  blue-wash: "#EAF1FB"
  pink-wash: "#FFE8F0"
  ok: "#267A60"
  wrong: "#BC4B53"
  ink: "#35253B"
  muted: "#756477"
  border: "#EBDDE4"
typography:
  greeting:
    fontFamily: HindSiliguri
    fontSize: "26sp"
    fontWeight: 600
    lineHeight: 1.3
  title-large:
    fontFamily: HindSiliguri
    fontSize: "22sp"
    fontWeight: 600
    lineHeight: 1.4
  title-medium:
    fontFamily: HindSiliguri
    fontSize: "18sp"
    fontWeight: 600
    lineHeight: 1.45
  title-small:
    fontFamily: HindSiliguri
    fontSize: "15sp"
    fontWeight: 600
    lineHeight: 1.45
  body-large:
    fontFamily: HindSiliguri
    fontSize: "17sp"
    lineHeight: 1.55
  body-medium:
    fontFamily: HindSiliguri
    fontSize: "15sp"
    lineHeight: 1.55
  body-small:
    fontFamily: HindSiliguri
    fontSize: "13sp"
    lineHeight: 1.5
  button:
    fontFamily: HindSiliguri
    fontSize: "16sp"
    fontWeight: 600
  chip:
    fontFamily: HindSiliguri
    fontSize: "14sp"
    lineHeight: 1.5
  navigation-selected:
    fontFamily: HindSiliguri
    fontSize: "12sp"
    fontWeight: 600
  navigation-unselected:
    fontFamily: HindSiliguri
    fontSize: "12sp"
    fontWeight: 400
rounded:
  chip: "12dp"
  panel: "16dp"
  greeting: "24dp"
  sheet-top: "28dp"
spacing:
  detail: "4dp"
  compact: "8dp"
  related: "12dp"
  panel: "16dp"
  page: "20dp"
  section: "24dp"
  end: "32dp"
components:
  button-primary:
    backgroundColor: "{colors.primary-deep}"
    textColor: "{colors.surface}"
    typography: "{typography.button}"
    rounded: "{rounded.panel}"
    padding: "14dp 22dp"
    height: "min 54dp"
  button-outlined:
    textColor: "{colors.primary-deep}"
    rounded: "{rounded.panel}"
    padding: "12dp 18dp"
    height: "min 50dp"
  chip-selected:
    backgroundColor: "{colors.blush}"
    textColor: "{colors.ink}"
    typography: "{typography.chip}"
    rounded: "{rounded.chip}"
    padding: "8dp"
  panel:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.panel}"
    padding: "16dp"
  intro:
    backgroundColor: "{colors.pink-wash}"
    rounded: "{rounded.panel}"
    padding: "20dp"
  navigation:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary-deep}"
    typography: "{typography.navigation-selected}"
    height: "80dp"
  report-field:
    backgroundColor: "rgba(252, 229, 238, 0.5)"
    textColor: "{colors.ink}"
    rounded: "{rounded.panel}"
  answer-selected:
    backgroundColor: "{colors.blush}"
    textColor: "{colors.ink}"
    rounded: "{rounded.panel}"
    padding: "16dp"
---

# Design System: Pookie Prep

## Overview

**Creative North Star: "Playful companion"**

A friendly companion's study corner: warm pink surroundings, white reading paper, plum ink, and the expressive white puppy. The user selected a softer, more colorful direction while preserving the Bengali, pink, and puppy identity. Pastel introductions make each area welcoming; readable content remains calm enough for timed practice.

This is a code-led record of the implemented Flutter Android interface, informed by the user-pinned direction in `.impeccable/direction.md`. No approved visual comp exists. Native dimensions use logical pixels (dp) and scalable type (sp); these strings preserve native intent rather than defining CSS. The implementation uses a fixed light scheme. Dark mode is not implemented. Source authority is `lib/core/theme.dart`, `lib/core/study_widgets.dart`, `lib/core/page.dart`, and the feature screens; built-in Material 3 defaults supply styles that are not explicitly overridden.

**Key Characteristics:**

- Bengali-first bundled HindSiliguri type.
- Pink identity, white puppy, and distinct pastel study areas.
- Flat reading surfaces with gently rounded controls.
- Immediate practice feedback and completion-only celebration.
- Safe insets, readable width, and adaptive native navigation.

## Colors

Pink provides emotional warmth; deeper rose, plum, and green communicate actions and study states. Frontmatter values are normative and retain the code's color names.

### Primary

- **Companion Pink (`primary`)** supports friendly accents and answered-question markers; use plum ink on this light fill.
- **Action Rose (`primary-deep`)** carries primary actions, selection borders, active navigation, timers, and progress.
- **Blush (`blush`)** carries selected controls and quiet action tracks. **Pink Wash (`pink-wash`)** welcomes students in companion introductions.

### Secondary

- **Study Violet (`accent`)** identifies saved questions, review flags, and news. **Lilac (`lilac`)** is its quiet introductory fill.
- **Apricot (`apricot`)** highlights practice and guidance. **Blue Wash (`blue-wash`)** is an available theme wash; it does not imply a new interaction state.

### Tertiary

- **Learning Green (`ok`)** identifies correct answers, revision, and learning progress. **Mint (`mint`)** provides the corresponding light fill.
- **Correction Rose (`wrong`)** identifies wrong answers and score deductions without a punitive voice.

### Neutral

- **Warm Ground (`bg`)** is the scaffold background; **Reading Paper (`surface`)** holds content and navigation.
- **Plum Ink (`ink`)** is the default reading color. **Quiet Plum (`muted`)** is secondary copy and unselected navigation.
- **Soft Divider (`border`)** separates controls and rows without adding heavy visual weight.

**The Meaningful State Rule.** Pair correctness, selection, bookmark, and review colors with explicit icons or text; color alone must not carry the meaning.

## Typography

**Display and Body Font:** bundled HindSiliguri. No separate display or monospace family is defined. Preserve the family across Material components rather than introducing an English-oriented pairing.

The Bengali letterforms need generous line height and room to wrap. Frontmatter captures the explicit overrides; unset weights and other headline roles inherit Material 3 rather than forming an invented custom scale.

- **Greeting:** personal home greeting, distinct from reusable section titles.
- **Title large / medium / small:** page content titles, section headings, and group labels respectively.
- **Body large / medium / small:** answers or emphasized reading, explanations, and supporting metadata.
- **Button / chip / navigation:** compact controls with Bengali sentence case; selected navigation gains weight and action rose.

**The Bengali Reading Rule.** Let text wrap and grow with system text scaling. Do not shrink Bengali copy to keep a decorative panel or fixed row intact.

## Layout

Use `PookieScaffold` for safe system insets and a centered reading area capped at 840dp. Feature lists typically have 20dp side gutters and 32dp bottom padding. Related controls use compact gaps; major study sections commonly use 24dp gaps. Introduction panels have 20dp padding; ordinary panels commonly have 16dp, while saved-question cards use 18dp. Layout follows content rather than a universal card grid.

Below 760dp window width, the five destinations use the 80dp bottom navigation bar. At 760dp and above, a navigation rail replaces it; at 1100dp and above, the rail extends with a 204dp minimum width. Preserve page state through the indexed stack and enable tickers only for the active destination. The setup bottom action has its own 800dp maximum width.

Native icon and text controls have a 48dp minimum interactive size. Filled buttons are at least 54dp tall, outlined buttons at least 50dp, and segmented controls at least 52dp. Treat these as minimums that can grow with text. The app bar is 64dp tall with 20dp title spacing.

## Elevation & Depth

Content cards and app bars are flat: elevation and scrolled-under elevation are zero, and explicit surface tint is removed from app bars and navigation. Tonal layering, white panels, and quiet dividers provide structure. Dialogs and sheets retain native Material behavior; there is no custom shadow vocabulary to reproduce as a web shadow.

**The Quiet Surface Rule.** Keep reading content flat; reserve tonal contrast and borders for hierarchy and meaningful state.

## Shapes

Reusable content panels, buttons, dialogs, and answer choices share the 16dp corner language. Filter chips use 12dp corners. The home companion greeting and some feature dialogs use 24dp corners; bottom sheets have 28dp top corners. Keep these larger shapes for their existing contextual roles rather than rounding every small element equally. Answer borders are 1.5dp; standard theme dividers and chip outlines are 1dp.

## Components

### Buttons

Friendly, direct native Material controls. Primary filled actions use action rose with white labels and the frontmatter padding. Outlined actions use the quiet border; text and icon actions keep the minimum touch target. Filled-button state animation lasts 160ms. Retain Material ink, focus, disabled, and pressed handling; do not invent a web hover lift.

### Chips and segmented controls

White unselected filter chips gain blush fill and a rose checkmark when selected, while text stays plum. Chips wrap with 8dp horizontal and run spacing. Segmented controls use blush / rose when selected and white / muted when unselected. Preserve native selection semantics.

### Cards / Containers

White, flat, rounded reading surfaces; borders are contextual rather than required on every panel. `StudyIntro` uses pink wash by default, mint for green learning roles, and lilac for violet saved/news roles. It places a wrapping title next to a 64dp puppy or 28dp icon and follows it with readable description text. `StudySection` gives related content a title and optional subtitle. `StudyEmptyState` pairs a 120dp puppy with centered, wrapping copy and an optional action.

### Inputs / Fields

The question-report field is a filled two-line native `TextField`, with half-opacity blush and a 16dp outline shape. Focus, caret, error, and disabled handling inherit Material; no app-wide custom input theme or custom focus glow is implemented.

### Navigation

White native navigation with blush selection indicators, rose selected icons and labels, and muted unselected labels. Preserve the bottom-bar-to-rail behavior described in Layout. Tab content changes directly; do not add decorative transition animation to tab or quiz-question navigation. Native route and Material control feedback remain native.

### Answer selection and review

An answer is a full-width, wrapping interactive panel with 16dp padding. Selection changes white to blush, switches the outline to rose, fills the letter marker, and adds a check icon. The visual state transition uses 180ms `easeOutCubic`, falling to zero duration when `MediaQuery.disableAnimationsOf(context)` is true. The answer commits immediately; animation never gates navigation. Review distinguishes correct, wrong, skipped, and flagged states with written or icon cues alongside color.

### Companion and completion

Keep the white puppy's greeting, thinking, cheering, sleepy, and encouraging expressions as brand assets. Use encouraging Bengali copy even after a difficult session. Results with at least 80% accuracy may show a single 2500ms confetti pass; the overlay ignores pointer input and disappears at completion. Reduced-motion mode suppresses confetti and stops its controller. Celebration belongs to completed sessions, never repeated taps or timed-question changes.

## Do's and Don'ts

### Do:

- **Do** preserve Bengali copy, the bundled HindSiliguri family, pink identity, and white puppy.
- **Do** use safe insets, the 840dp reading cap, adaptive navigation, and controls of at least 48dp.
- **Do** keep white reading surfaces quiet and allow Bengali text to wrap at enlarged system text sizes.
- **Do** pair state colors with meaningful labels or icons and respect reduced-motion settings.

### Don't:

- **Don't** claim dark-mode support or introduce a second visual identity without a new direction decision.
- **Don't** add decorative animation to tab changes or quiz-question navigation.
- **Don't** make mascot decoration crowd timed practice, delay answers, or obscure exam feedback.
- **Don't** treat the sidecar's browser previews as Flutter source or normative CSS tokens.
