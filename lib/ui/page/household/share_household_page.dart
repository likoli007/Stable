import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/ui/common/page/page_body.dart';

class ShareHouseholdPage extends StatelessWidget {
  final String groupId;

  const ShareHouseholdPage({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: 'Share Household',
      body: Column(
        children: [
          const Text('Share this household with others'),
          Text("GroupId: $groupId")
        ],
      ),
    );
    // TODO share android popup
    // TODO make a big icon page out of this
  }
}
