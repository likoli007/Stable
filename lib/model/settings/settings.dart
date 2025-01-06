import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;
  final Color themeColor;

  Settings({
    this.themeMode = ThemeMode.dark,
    this.themeColor = Colors.deepOrangeAccent,
  });

  Settings copyWith({
    ThemeMode? themeMode,
    Color? themeColor,
    String? fontFamily,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}
