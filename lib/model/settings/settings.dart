import 'package:flutter/material.dart';

class Settings {
  final ThemeMode themeMode;

  Settings({
    this.themeMode = ThemeMode.system,
  });

  Settings copyWith({
    ThemeMode? themeMode,
  }) {
    return Settings(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
