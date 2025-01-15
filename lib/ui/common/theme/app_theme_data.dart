import 'package:flutter/material.dart';
import 'package:stable/ui/common/theme/app_color_scheme.dart';

@immutable
class AppThemeData {
  const AppThemeData({
    required this.colorScheme,
    required this.materialThemeData,
  });

  final AppColorScheme colorScheme;
  final ThemeData materialThemeData;

  List<Object?> get props => [
        colorScheme,
        materialThemeData,
      ];
}
