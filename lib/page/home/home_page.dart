import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/service/household_service.dart';

import '../../common/widget/loading_future_builder.dart';
import '../../common/widget/loading_stream_builder.dart';
import '../../model/household/household.dart';
import '../../model/inhabitant/inhabitant.dart';
import '../../service/inhabitant_service.dart';
import '../household/add_household_page.dart';
import '../household/household_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _userProvider = GetIt.instance<UserService>();
  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: "Household Name Placeholder",
      child: LoadingStreamBuilder(
          stream: _userProvider
              .getInhabitantStream(FirebaseAuth.instance.currentUser!.uid),
          builder: homePageBuilder),
    );
    // TODO add welcome message
    // TODO add an overview of the household (unfinished repeating tasks, rotary tasks)
    // TODO add a center floating button to quickly add a new task
    // TODO add bottom navbar with home/overview, tasklist and household (on web combine it with the appbar)
  }

  Widget homePageBuilder(BuildContext context, Inhabitant? data) {
    //TODO: if inhabitant is null, something went horribly wrong somewhere

    int householdCount = data!.households.length;
    print(householdCount);
    return householdCount == 0
        ? buildDefaultHomePage(context)
        : buildHouseholdListPage(data.households);
  }

  Widget buildDefaultHomePage(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'You have no households at the moment.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHouseholdPage(),
                  ),
                );
              },
              child: const Text('Create a New Household'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to a screen where the user can join an existing household
              },
              child: const Text('Join an Existing Household'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHouseholdListPage(List<DocumentReference> households) {
    return LoadingStreamBuilder<List<Household>>(
        stream: _householdProvider.getHouseholdsStreamByIds(households),
        builder: buildHouseholdList);
  }

  Widget buildHouseholdList(BuildContext context, List<Household> households) {
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
