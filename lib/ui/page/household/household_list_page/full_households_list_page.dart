import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/ui/common/widget/speed_dial/custom_speed_dial_child.dart';
import 'package:stable/ui/common/widget/speed_dial/speed_dials.dart';
import 'package:stable/ui/page/household/household_page.dart';

class FullHouseholdsListPage extends StatelessWidget {
  final Widget showCreateHouseholdDialog;
  final Widget showJoinHouseholdDialog;
  final List<DocumentReference> households;

  FullHouseholdsListPage({
    super.key,
    required this.showCreateHouseholdDialog,
    required this.showJoinHouseholdDialog,
    required this.households,
  });

  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: "Your households",
      showBackButton: false,
      body: _buildHouseholdListPage(context),
      floatingActionButton: _buildSpeedDials(context),
    );
  }

  Widget _buildHouseholdListPage(BuildContext context) {
    return LoadingStreamBuilder<List<Household>>(
        stream: _householdProvider.getHouseholdsStreamByIds(households),
        builder: _buildHouseholdList);
  }

  Widget _buildHouseholdList(BuildContext context, List<Household> households) {
    return ListView.builder(
      itemCount: households.length,
      itemBuilder: (context, index) {
        final household = households[index];
        return ListTile(
          title: Text(household.name),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HouseholdPage(household: household),
              fullscreenDialog: false,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpeedDials(BuildContext context) {
    return SpeedDials(
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        CustomSpeedDialChild(
          icon: const Icon(Icons.domain_add),
          label: 'Create a new household',
          context: context,
          onTap: () => showDialog(
            context: context,
            builder: (context) => showCreateHouseholdDialog,
          ),
        ),
        CustomSpeedDialChild(
          icon: const Icon(Icons.login),
          label: 'Join an existing household',
          context: context,
          onTap: () => showDialog(
            context: context,
            builder: (context) => showJoinHouseholdDialog,
          ),
        ),
      ],
    );
  }
}
