import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/page/task/common_task_view.dart';
import 'package:stable/service/task_service.dart';

import 'package:stable/page/task/add_task_page.dart';

import 'package:stable/model/subtask/subtask.dart';

import '../../model/household/household.dart';
import '../../service/household_service.dart';

class HouseholdTaskPage extends StatelessWidget {
  HouseholdTaskPage({Key? key, required this.householdReference})
      : super(key: key);

  String householdReference;

  final _taskProvider = GetIt.instance<TaskService>();
  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
        title: 'Tasks',
        floatingActionButton: _buildHouseholdTaskPageFloatingButton(context),
        child: _buildHouseholdStream());
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
      isFailedView: false,
    );
  }
}
