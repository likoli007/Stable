import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';

class HouseholdStatisticsPage extends StatelessWidget {
  HouseholdStatisticsPage({Key? key, required this.householdReference})
      : super(key: key);

  final String householdReference;

  final _householdProvider = GetIt.instance<HouseholdService>();
  final _taskProvider = GetIt.instance<TaskService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(title: 'Task Statistics', body: _buildHouseholdStream());
  }

  Widget _buildHouseholdStream() {
    return LoadingStreamBuilder(
        stream: _householdProvider.getHouseholdStream(householdReference),
        builder: _buildTaskStream);
  }

  Widget _buildTaskStream(BuildContext context, Household? household) {
    List<DocumentReference> totalTaskHistory = [];

    for (DocumentReference ref in household!.doneTaskHistory) {
      totalTaskHistory.add(ref);
    }
    for (DocumentReference ref in household.failedTaskHistory) {
      totalTaskHistory.add(ref);
    }

    return LoadingStreamBuilder(
        stream: _taskProvider.getTasksStreamByRefs(totalTaskHistory),
        builder: _buildStatisticsPage);
  }

  Widget _buildStatisticsPage(BuildContext context, List<Task> tasks) {
    return Container();
  }
}
