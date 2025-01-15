import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/loading_stream_builder.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/service/household_service.dart';
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
            ),
          ),
        );
      },
    );
  }

  Widget _buildSpeedDials(BuildContext context) {
    return SpeedDial(
      //TODO extract this to a separate widget
      icon: Icons.add,
      activeIcon: Icons.close,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      childPadding: const EdgeInsets.all(SMALL_GAP),
      spaceBetweenChildren: SMALL_GAP,
      isOpenOnStart: false,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.domain_add),
          label: 'Create a new household',
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onTap: () => showDialog(
            context: context,
            builder: (context) => showCreateHouseholdDialog,
          ),
        ),
        SpeedDialChild(
          child: const Icon(Icons.login),
          label: 'Join an existing household',
          shape: const CircleBorder(),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          onTap: () => showDialog(
            context: context,
            builder: (context) => showJoinHouseholdDialog,
          ),
        ),
      ],
    );
  }
}
