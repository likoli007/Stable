import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/builder/loading_future_builder.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';
import 'package:stable/ui/page/task/common_task_view.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';

class UserTaskPage extends StatelessWidget {
  UserTaskPage({super.key});

  final _householdProvider = GetIt.instance<HouseholdService>();
  final _userProvider = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(title: 'Tasks', body: _buildUserFuture());
  }

  Widget _buildUserFuture() {
    return LoadingStreamBuilder(
      stream: _userProvider
          .getInhabitantStream(FirebaseAuth.instance.currentUser!.uid),
      builder: _buildHouseholdsStream,
    );
  }

  Widget _buildHouseholdsStream(BuildContext context, Inhabitant? user) {
    return LoadingStreamBuilder(
      stream: _householdProvider.getUserHouseholds(user!),
      builder: _buildTaskView,
    );
  }

  Widget _buildTaskView(BuildContext context, List<Household?> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final household = data[index];
        return ListTile(
          title: Text(household!.name),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: STANDARD_GAP, vertical: SMALL_GAP),
            child: CommonTaskView(
              household: household,
              isUserView: false,
              isFailedView: false,
            ),
          ),
        );
      },
    );
  }
}
