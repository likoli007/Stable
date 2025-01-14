import 'package:flutter/material.dart';

import '../../model/inhabitant/inhabitant.dart';

class UserProfilePicture extends StatelessWidget {
  final double size;
  final Inhabitant user;

  const UserProfilePicture({
    Key? key,
    required this.user,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String firstChar =
        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: user.profileColor,
      child: Text(
        firstChar,
        style: TextStyle(
          fontSize: size / 2,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
