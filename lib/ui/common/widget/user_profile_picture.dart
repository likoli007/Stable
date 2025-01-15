import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/widget/loading_stream_builder.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';

class UserProfilePicture extends StatelessWidget {
  final double size;
  final String user;

  final _inhabitantService = GetIt.instance<InhabitantService>();

  UserProfilePicture({
    super.key,
    required this.user,
    this.size = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return LoadingStreamBuilder(
        stream: _inhabitantService.getInhabitantStream(user),
        builder: _buildAvatar);
  }

  Widget _buildAvatar(BuildContext context, Inhabitant? user) {
    final String firstChar =
        user!.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

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
