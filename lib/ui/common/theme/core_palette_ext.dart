// Copied from theming demo https://github.com/FiveDotTwelve/dynamic_colors/
import 'package:flutter/material.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

extension ColorPaletteExt on CorePalette {
  ColorScheme toMaterialColorScheme({
    required Brightness brightness,
  }) {
    final Scheme scheme;

    switch (brightness) {
      case Brightness.light:
        scheme = Scheme.lightFromCorePalette(this);
        break;
      case Brightness.dark:
        scheme = Scheme.darkFromCorePalette(this);
        break;
    }
    return ColorScheme(
      primary: Color(scheme.primary),
      onPrimary: Color(scheme.onPrimary),
      primaryContainer: Color(scheme.primaryContainer),
      onPrimaryContainer: Color(scheme.onPrimaryContainer),
      secondary: Color(scheme.secondary),
      onSecondary: Color(scheme.onSecondary),
      secondaryContainer: Color(scheme.secondaryContainer),
      onSecondaryContainer: Color(scheme.onSecondaryContainer),
      tertiary: Color(scheme.tertiary),
      onTertiary: Color(scheme.onTertiary),
      tertiaryContainer: Color(scheme.tertiaryContainer),
      onTertiaryContainer: Color(scheme.onTertiaryContainer),
      error: Color(scheme.error),
      onError: Color(scheme.onError),
      errorContainer: Color(scheme.errorContainer),
      onErrorContainer: Color(scheme.onErrorContainer),
      outline: Color(scheme.outline),
      surface: Color(scheme.surface),
      onSurface: Color(scheme.onSurface),
      surfaceContainerHighest: Color(scheme.surfaceVariant),
      onSurfaceVariant: Color(scheme.onSurfaceVariant),
      inverseSurface: Color(scheme.inverseSurface),
      onInverseSurface: Color(scheme.inverseOnSurface),
      inversePrimary: Color(scheme.inversePrimary),
      shadow: Color(scheme.shadow),
      brightness: brightness,
    );
  }
}
