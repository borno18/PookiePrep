import 'package:flutter/material.dart';

class PookieColors {
  static const bg = Color(0xFFFFF8FA);
  static const surface = Colors.white;
  static const blush = Color(0xFFFCE5EE);
  static const primary = Color(0xFFFF9DBF);
  static const primaryDeep = Color(0xFFD6336C);
  static const accent = Color(0xFF7050A0);
  static const mint = Color(0xFFE6F4EE);
  static const lilac = Color(0xFFF0E9FA);
  static const apricot = Color(0xFFFFEEDF);
  static const blueWash = Color(0xFFEAF1FB);
  static const pinkWash = Color(0xFFFFE8F0);
  static const ok = Color(0xFF267A60);
  static const wrong = Color(0xFFBC4B53);
  static const ink = Color(0xFF35253B);
  static const muted = Color(0xFF756477);
  static const border = Color(0xFFEBDDE4);
}

ThemeData buildPookieTheme() {
  final scheme =
      ColorScheme.fromSeed(seedColor: PookieColors.primaryDeep).copyWith(
    primary: PookieColors.primaryDeep,
    onPrimary: Colors.white,
    primaryContainer: PookieColors.blush,
    onPrimaryContainer: PookieColors.primaryDeep,
    secondary: PookieColors.accent,
    surface: PookieColors.surface,
    onSurface: PookieColors.ink,
    onSurfaceVariant: PookieColors.muted,
    outline: PookieColors.border,
    outlineVariant: PookieColors.border,
    secondaryContainer: PookieColors.lilac,
    onSecondaryContainer: PookieColors.accent,
    tertiary: PookieColors.ok,
    tertiaryContainer: PookieColors.mint,
    onTertiaryContainer: PookieColors.ok,
    error: PookieColors.wrong,
  );
  final base = ThemeData(
      useMaterial3: true, colorScheme: scheme, fontFamily: 'HindSiliguri');
  const shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)));
  return base.copyWith(
    scaffoldBackgroundColor: PookieColors.bg,
    splashFactory: InkSparkle.splashFactory,
    textTheme: base.textTheme
        .apply(bodyColor: PookieColors.ink, displayColor: PookieColors.ink)
        .copyWith(
          bodyMedium: const TextStyle(
              fontFamily: 'HindSiliguri',
              fontSize: 15,
              height: 1.55,
              color: PookieColors.ink),
          bodyLarge: const TextStyle(
              fontFamily: 'HindSiliguri',
              fontSize: 17,
              height: 1.55,
              color: PookieColors.ink),
          titleLarge: const TextStyle(
              fontFamily: 'HindSiliguri',
              fontSize: 22,
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: PookieColors.ink),
          titleMedium: const TextStyle(
              fontFamily: 'HindSiliguri',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: PookieColors.ink),
          titleSmall: const TextStyle(
              fontFamily: 'HindSiliguri',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: PookieColors.ink),
          bodySmall: const TextStyle(
              fontFamily: 'HindSiliguri',
              fontSize: 13,
              height: 1.5,
              color: PookieColors.muted),
        ),
    appBarTheme: const AppBarTheme(
      backgroundColor: PookieColors.bg,
      foregroundColor: PookieColors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleSpacing: 20,
      toolbarHeight: 64,
      titleTextStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: PookieColors.ink),
    ),
    cardTheme: const CardThemeData(
        color: PookieColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: shape),
    chipTheme: ChipThemeData(
      backgroundColor: PookieColors.surface,
      selectedColor: PookieColors.blush,
      checkmarkColor: PookieColors.primaryDeep,
      labelStyle: const TextStyle(
          fontFamily: 'HindSiliguri',
          color: PookieColors.ink,
          fontSize: 14,
          height: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      side: const BorderSide(color: PookieColors.border),
    ),
    filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
      minimumSize: const Size(0, 54),
      animationDuration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      shape: shape,
      textStyle: const TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 16,
          fontWeight: FontWeight.w600),
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      minimumSize: const Size(0, 50),
      shape: shape,
      side: const BorderSide(color: PookieColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
    )),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      minimumSize: const Size(48, 48),
      textStyle: const TextStyle(
          fontFamily: 'HindSiliguri',
          fontSize: 14,
          fontWeight: FontWeight.w600),
    )),
    navigationBarTheme: NavigationBarThemeData(
      height: 80,
      backgroundColor: PookieColors.surface,
      indicatorColor: PookieColors.blush,
      surfaceTintColor: Colors.transparent,
      labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
            fontFamily: 'HindSiliguri',
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w400,
            color: states.contains(WidgetState.selected)
                ? PookieColors.primaryDeep
                : PookieColors.muted,
          )),
    ),
    navigationRailTheme: const NavigationRailThemeData(
      backgroundColor: PookieColors.surface,
      indicatorColor: PookieColors.blush,
      selectedIconTheme: IconThemeData(color: PookieColors.primaryDeep),
      unselectedIconTheme: IconThemeData(color: PookieColors.muted),
      selectedLabelTextStyle: TextStyle(
          fontFamily: 'HindSiliguri',
          color: PookieColors.primaryDeep,
          fontWeight: FontWeight.w600),
    ),
    dividerTheme: const DividerThemeData(
        color: PookieColors.border, thickness: 1, space: 1),
    listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8)),
    iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
            minimumSize: const Size(48, 48),
            foregroundColor: PookieColors.ink)),
    segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
      minimumSize: const WidgetStatePropertyAll(Size(48, 52)),
      backgroundColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? PookieColors.blush
              : PookieColors.surface),
      foregroundColor: WidgetStateProperty.resolveWith((states) =>
          states.contains(WidgetState.selected)
              ? PookieColors.primaryDeep
              : PookieColors.muted),
    )),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: PookieColors.ink,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    dialogTheme: const DialogThemeData(
        backgroundColor: PookieColors.surface, shape: shape),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: PookieColors.surface,
      showDragHandle: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: PookieColors.primaryDeep, linearTrackColor: PookieColors.blush),
    sliderTheme: const SliderThemeData(
        activeTrackColor: PookieColors.primaryDeep,
        thumbColor: PookieColors.primaryDeep,
        inactiveTrackColor: PookieColors.blush,
        trackHeight: 6),
  );
}
