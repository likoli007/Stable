// Copied from theming demo https://github.com/FiveDotTwelve/dynamic_colors/
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stable/common/theme/app_color_scheme.dart';
import 'package:stable/common/theme/app_theme_data.dart';
import 'package:stable/common/theme/core_palette_ext.dart';

abstract class AppThemeFactory {
  AppThemeFactory._();

  static Future<AppThemeData> create({
    required bool isDark,
  }) {
    return _createAppTheme(isDark);
  }

  static Future<AppThemeData> _createAppTheme(bool isDark) async {
    final brightness = isDark ? Brightness.dark : Brightness.light;

    final dynamicColorsScheme = await _getDynamicColors(brightness);

    final appColorScheme = AppColorScheme.fromMaterialColorScheme(
      dynamicColorsScheme!,
      disabled: Colors.grey,
      onDisabled: Colors.black,
    );

    final materialThemeData = ThemeData(
      colorScheme: appColorScheme.materialColorScheme,
      brightness: appColorScheme.brightness,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: appColorScheme.primary,
        foregroundColor: appColorScheme.onPrimary,
      ),
    );

    return AppThemeData(
      colorScheme: appColorScheme,
      materialThemeData: materialThemeData,
    );
  }

  static Future<ColorScheme?> _getDynamicColors(Brightness brightness) {
    try {
      return DynamicColorPlugin.getCorePalette().then((corePallet) =>
          corePallet?.toMaterialColorScheme(brightness: brightness));
    } on PlatformException {
      return Future.value(null);
    }
  }
}
