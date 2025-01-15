import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/page/page_body.dart';
import 'package:stable/common/util/shared_ui_constants.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/common/page/page_body.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/page/task/common_task_view.dart';
import 'package:stable/service/task_service.dart';

import 'package:stable/page/task/add_task_page.dart';

import 'package:stable/model/subtask/subtask.dart';

import '../../model/household/household.dart';
import '../../service/household_service.dart';

class HouseholdTaskHistoryPage extends StatelessWidget {
  HouseholdTaskHistoryPage({Key? key, required this.householdReference})
      : super(key: key);

  String householdReference;

  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(title: 'Failed Tasks', body: _buildHouseholdStream());
  }

  Widget _buildHouseholdStream() {
    return LoadingStreamBuilder<Household?>(
      stream: _householdProvider.getHouseholdStream(householdReference),
      builder: _buildTaskStream,
    );
  }

  Widget _buildTaskStream(BuildContext context, Household? data) {
    return CommonTaskView(
        household: data!, showAssignee: true, isFailedView: true);
  }
}
