import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

class SpeedDials extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final List<SpeedDialChild> children;

  const SpeedDials({
    Key? key,
    required this.icon,
    required this.activeIcon,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: icon,
      activeIcon: activeIcon,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(BORDER_RADIUS),
      ),
      childPadding: const EdgeInsets.all(SMALL_GAP),
      spaceBetweenChildren: SMALL_GAP,
      isOpenOnStart: false,
      children: children,
    );
  }

  SpeedDialChild customSpeedDialChild({
    required BuildContext context,
    required Icon icon,
    required String label,
    Color? backgroundColor,
    Color? foregroundColor,
    required Function() onTap,
  }) {
    return SpeedDialChild(
      child: icon,
      label: label,
      shape: const CircleBorder(),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      foregroundColor:
          foregroundColor ?? Theme.of(context).colorScheme.onPrimary,
      onTap: onTap,
    );
  }
}
