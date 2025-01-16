import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/widget/dialog/text_input_dialog.dart';
import 'package:stable/ui/page/household/household_list_page/empty_households_list_page.dart';
import 'package:stable/service/household_service.dart';

import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/ui/page/household/household_list_page/full_households_list_page.dart';
import 'package:stable/ui/page/login/introduction_page.dart';

class HouseholdsListPage extends StatelessWidget {
  HouseholdsListPage({super.key});

  final _userProvider = GetIt.instance<InhabitantService>();
  final _householdService = GetIt.instance.get<HouseholdService>();
  final _inhabitantService = GetIt.instance.get<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, show login page
      // (previously caused unexpected error)
      return const IntroductionPage();
    } else {
      return LoadingStreamBuilder(
          stream: _userProvider
              .getInhabitantStream(FirebaseAuth.instance.currentUser!.uid),
          builder: _homePageBuilder);
    }
  }

  Widget _homePageBuilder(BuildContext context, Inhabitant? data) {
    final int householdCount = data!.households.length;
    return householdCount == 0
        ? EmptyHouseholdsListPage(
            showCreateHouseholdDialog: _showCreateHouseholdDialog(context),
            showJoinHouseholdDialog: _showJoinHouseholdDialog(context),
          )
        : FullHouseholdsListPage(
            showCreateHouseholdDialog: _showCreateHouseholdDialog(context),
            showJoinHouseholdDialog: _showJoinHouseholdDialog(context),
            households: data.households,
          );
  }

  Widget _showCreateHouseholdDialog(BuildContext context) {
    return TextInputDialog(
      title: 'Create household',
      buttonText: 'Create',
      infoText: "Pro tip: Add an emoji at the beginning of the name to better "
          "differentiate between several households. 😏",
      textFieldInitialValue: "Household name",
      onSubmit: (name) async {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        try {
          DocumentReference householdReference =
              await _householdService.createHousehold(userId: uid, name: name);
          await _inhabitantService.addHouseholdToInhabitant(
            uid: uid,
            newRef: householdReference,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Start by inviting your friends to $name.'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
            ),
          );
        }
      },
    );
  }

  Widget _showJoinHouseholdDialog(BuildContext context) {
    return TextInputDialog(
      title: 'Join household',
      buttonText: 'Join',
      infoText: "You can join your friend's household. "
          "Navigate them to their household settings to share the household invite code with you.",
      textFieldInitialValue: "Invite code",
      maxInputLength: 8,
      onSubmit: (groupId) async {
        String uid = FirebaseAuth.instance.currentUser!.uid;
        try {
          await _householdService.joinHouseholdByGroupId(
            groupId: groupId,
            userId: uid,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Welcome to a new household!.'),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: No household found with this invite code.'),
            ),
          );
        }
      },
    );
  }
}
