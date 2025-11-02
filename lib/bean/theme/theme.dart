import 'package:flutter/material.dart';

class ThemeGetter {
  static dynamic getDarkTheme(Color color) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: color,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: color),
      sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.alwaysVisible),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static dynamic getOLEDDarkTheme(Color color) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: color,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: color),
      sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.alwaysVisible),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(
        surface: Colors.black,
        onSurface: Colors.white,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
    );
  }

  static dynamic getLightTheme(Color color) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: color,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: color),
      sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.alwaysVisible),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static dynamic getDynamicLightTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),
      sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.alwaysVisible),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static dynamic getDynamicDarkTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),
      sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.alwaysVisible),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
    );
  }

  static dynamic getDynamicOLEDDarkTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      progressIndicatorTheme: ProgressIndicatorThemeData(color: colorScheme.primary),
      sliderTheme: SliderThemeData(showValueIndicator: ShowValueIndicator.alwaysVisible),
      pageTransitionsTheme: const PageTransitionsTheme(builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
      }),
      scaffoldBackgroundColor: Colors.black,
      colorScheme: colorScheme.copyWith(
        surface: Colors.black,
        onSurface: Colors.white,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
      ),
    );
  }
}