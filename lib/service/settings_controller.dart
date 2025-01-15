import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stable/model/settings/settings.dart';

class SettingsController {
  final _settingsController = BehaviorSubject<Settings>.seeded(Settings());

  Stream<Settings> get settingsStream => _settingsController.stream;

  void updateThemeMode(ThemeMode themeMode) =>
      _updateSettings(themeMode: themeMode);

  void _updateSettings({ThemeMode? themeMode}) {
    final currentSettings = _settingsController.value;
    final updatedSettings = currentSettings.copyWith(themeMode: themeMode);

    _settingsController.add(updatedSettings);
  }
}
