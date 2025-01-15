import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomSpeedDialChild extends SpeedDialChild {
  CustomSpeedDialChild({
    required BuildContext context,
    required Icon icon,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
    required VoidCallback onTap,
  }) : super(
          child: icon,
          label: label,
          shape: const CircleBorder(),
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.primary,
          foregroundColor:
              foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
          onTap: onTap,
        );
}
