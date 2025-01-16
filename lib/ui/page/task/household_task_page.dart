import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/ui/page/task/common_task_view.dart';
import 'package:stable/ui/page/task/add_task_page.dart';

class HouseholdTaskPage extends StatelessWidget {
  final String householdReference;

  HouseholdTaskPage({super.key, required this.householdReference});

  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(
        title: 'Tasks',
        floatingActionButton: _buildHouseholdTaskPageFloatingButton(context),
        body: _buildHouseholdStream());
  }

  FloatingActionButton _buildHouseholdTaskPageFloatingButton(
      BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Add',
      child: const Icon(Icons.add),
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
      isFailedView: false,
    );
  }
}
