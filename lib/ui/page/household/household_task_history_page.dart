import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/widget/loading_stream_builder.dart';
import 'package:stable/ui/page/task/common_task_view.dart';

import 'package:stable/model/household/household.dart';
import 'package:stable/service/household_service.dart';

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
