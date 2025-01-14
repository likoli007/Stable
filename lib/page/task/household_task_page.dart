import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/common/page/page_layout.dart';
import 'package:stable/page/task/common_task_view.dart';
import 'package:stable/page/task/add_task_page.dart';

import '../../model/household/household.dart';
import '../../service/household_service.dart';

class HouseholdTaskPage extends StatelessWidget {
  HouseholdTaskPage({Key? key, required this.householdReference})
      : super(key: key);

  String householdReference;

  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageLayout(
        title: 'Tasks',
        floatingActionButton: _buildHouseholdTaskPageFloatingButton(context),
        body: _buildHouseholdStream());
  }

  FloatingActionButton _buildHouseholdTaskPageFloatingButton(
      BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddTaskPage(
              householdRef: householdReference,
            ),
          ),
        );
      },
      tooltip: 'Add',
      child: const Icon(Icons.add),
    );
  }

  Widget _buildHouseholdStream() {
    return LoadingStreamBuilder<Household?>(
      stream: _householdProvider.getHouseholdStream(householdReference),
      builder: _buildTaskStream,
    );
  }

  Widget _buildTaskStream(BuildContext context, Household? data) {
    return CommonTaskView(
      household: data!,
      showAssignee: true,
    );
  }
}
