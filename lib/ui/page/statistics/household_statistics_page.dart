import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/model/task/task.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/service/task_service.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';

class HouseholdStatisticsPage extends StatelessWidget {
  HouseholdStatisticsPage({Key? key, required this.householdReference})
      : super(key: key);

  final String householdReference;

  final _householdProvider = GetIt.instance<HouseholdService>();
  final _taskProvider = GetIt.instance<TaskService>();
  final _inhabitantProvider = GetIt.instance<InhabitantService>();

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
    final Map<String, int> failedTaskCounts = {};
    final Iterable<Task> failedTasksList = tasks.where((task) => !task.isDone);

    for (var task in failedTasksList) {
      final userId = task.assignee!.id;
      failedTaskCounts[userId] = (failedTaskCounts[userId] ?? 0) + 1;
    }

    final List<DocumentReference> users =
        failedTasksList.map((task) => task.assignee!).toSet().toList();

    int doneTasks = tasks.where((task) => task.isDone).length;
    int failedTasks = failedTasksList.length;

    return Column(children: [
      _buildTotalTaskHistoryPieChart(doneTasks, failedTasks),
      SizedBox(
        height: BIG_GAP,
      ),
      _buildUserFailedTaskRanking(users, failedTaskCounts)
    ]);
  }

  Widget _buildUserFailedTaskRanking(List<DocumentReference> assigneeInfo,
      Map<String, int> failedTaskCountss) {
    return LoadingStreamBuilder(
        stream: _inhabitantProvider.getInhabitansStreamByIds(assigneeInfo),
        builder: (context, assigneeList) => _buildAssigneeInfoBarGraph(
            context, assigneeList, failedTaskCountss));
  }

  Widget _buildAssigneeInfoBarGraph(BuildContext context,
      List<Inhabitant> inhabitants, Map<String, int> failedTaskCounts) {
    final List<Map<String, dynamic>> barData = inhabitants.map((inhabitant) {
      final int failedCount = failedTaskCounts[inhabitant.id] ?? 0;
      return {
        'name': inhabitant.name,
        'failedCount': failedCount,
      };
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            'Failed Tasks by Assignee',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: barData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: (data['failedCount'] as int)!.toDouble(),
                        color: Colors.red,
                        width: 20,
                      ),
                    ],
                    showingTooltipIndicators: [],
                  );
                }).toList(),
                titlesData: _buildAssigneeInfoBarNotation(barData),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //this was taken from example of fl_graph, in the future could be split into multiple functions that each build one side
  //unnecessary for now
  FlTitlesData _buildAssigneeInfoBarNotation(
      List<Map<String, dynamic>> barData) {
    return FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: 1,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Text(value.toInt().toString(),
                style: TextStyle(fontSize: 12));
          },
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 60,
          getTitlesWidget: (value, meta) {
            if (value.toInt() >= 0 && value.toInt() < barData.length) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  barData[value.toInt()]['name'],
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildTotalTaskHistoryPieChart(int doneTasks, int failedTasks) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Task Completion Ratio',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: doneTasks.toDouble(),
                    title:
                        '${((doneTasks / (doneTasks + failedTasks)) * 100).toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: failedTasks.toDouble(),
                    title:
                        '${((failedTasks / (doneTasks + failedTasks)) * 100).toStringAsFixed(1)}%',
                    radius: 50,
                    titleStyle: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text('Done: $doneTasks'),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text('Failed: $failedTasks'),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
