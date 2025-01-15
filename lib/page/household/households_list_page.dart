import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/page/page_body.dart';
import 'package:stable/common/widget/big_icon_page.dart';
import 'package:stable/common/widget/full_width_button.dart';
import 'package:stable/page/household/join_household_page.dart';
import 'package:stable/service/household_service.dart';

import 'package:stable/common/widget/loading_stream_builder.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/page/household/add_household_page.dart';
import 'package:stable/page/household/household_page.dart';

class HouseholdsListPage extends StatelessWidget {
  HouseholdsListPage({super.key});

  final _userProvider = GetIt.instance<InhabitantService>();
  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: "Your households",
      showBackButton: false,
      body: LoadingStreamBuilder(
          stream: _userProvider
              .getInhabitantStream(FirebaseAuth.instance.currentUser!.uid),
          builder: _homePageBuilder),
    );
  }

  Widget _homePageBuilder(BuildContext context, Inhabitant? data) {
    final int householdCount = data!.households.length;
    return householdCount == 0
        ? _buildEmptyHomePage(context)
        : _buildHouseholdListPage(context: context, data.households);
  }

  Widget _buildEmptyHomePage(BuildContext context) {
    return BigIconPage(
      icon: const Icon(Icons.no_meeting_room, size: 200),
      title: "You have no household to manage, buddy.",
      text: "Join already existing household or create a "
          "new one and invite your friends. In case, you have any.",
      buttons: [
        FullWidthButton(
          icon: const Icon(Icons.domain_add),
          label: "Create a new household",
          alignment: Alignment.center,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHouseholdPage(),
            ),
          ),
        ),
        FullWidthButton(
          icon: const Icon(Icons.login),
          label: "Join an existing household",
          alignment: Alignment.center,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JoinHouseholdPage(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHouseholdListPage(List<DocumentReference> households,
      {required BuildContext context}) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JoinHouseholdPage(),
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
                builder: (context) => const AddHouseholdPage(),
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
