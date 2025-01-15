import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/page/page_body.dart';
import 'package:stable/common/widget/loading_stream_builder.dart';
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
        body: _buildHouseholdListPage(context));
  }

  Widget _buildHouseholdListPage(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => showCreateHouseholdDialog,
              ),
            );
          },
          child: const Text('Join an Existing Household'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => showJoinHouseholdDialog,
              ),
            );
          },
          child: const Text('Create a New Household'),
        ),
        Expanded(
          child: LoadingStreamBuilder<List<Household>>(
              stream: _householdProvider.getHouseholdsStreamByIds(households),
              builder: _buildHouseholdList),
        ),
      ],
    );
  }

  Widget _buildHouseholdList(BuildContext context, List<Household> households) {
    return ListView.builder(
      itemCount: households.length,
      itemBuilder: (context, index) {
        final household = households[index];
        return ListTile(
          title: Text(household.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HouseholdPage(household: household),
              ),
            );
          },
        );
      },
    );
  }
}
