import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

class SpeedDials extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final List<SpeedDialChild> children;

  const SpeedDials({
    super.key,
    required this.icon,
    required this.activeIcon,
    required this.children,
  });

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
}
