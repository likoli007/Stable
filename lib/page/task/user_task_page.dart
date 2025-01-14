import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/page/task/common_task_view.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';

import '../../common/widget/loading_future_builder.dart';
import '../../common/page/page_layout.dart';
import '../../model/household/household.dart';
import '../../model/inhabitant/inhabitant.dart';
import '../../service/task_service.dart';

class UserTaskPage extends StatelessWidget {
  UserTaskPage({Key? key}) : super(key: key);

  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();
  final _userProvider = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return PageLayout(title: 'Tasks', body: _buildUserFuture());
  }

  Widget _buildUserFuture() {
    return LoadingFutureBuilder(
      future:
          _userProvider.getInhabitant(FirebaseAuth.instance.currentUser!.uid),
      builder: _buildHouseholdsFuture,
    );
  }

  Widget _buildHouseholdsFuture(BuildContext context, Inhabitant? user) {
    return LoadingFutureBuilder(
      future: _householdProvider.getUserHouseholds(user!),
      builder: _buildTaskView,
    );
  }

  Widget _buildTaskView(BuildContext context, List<Household?> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final household = data[index];
        return ExpansionTile(
          maintainState: true,
          title: Text(household!.name),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: STANDARD_GAP, vertical: SMALL_GAP),
              child: CommonTaskView(
                household: household,
                showAssignee: false,
                isFailedView: false,
              ),
            ),
          ],
        );
      },
    );
  }
}
