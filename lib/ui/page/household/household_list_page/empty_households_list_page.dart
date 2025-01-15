import 'package:flutter/material.dart';
import 'package:stable/common/page/page_body.dart';
import 'package:stable/common/widget/big_icon_page.dart';
import 'package:stable/common/widget/full_width_button.dart';

class EmptyHouseholdsListPage extends StatelessWidget {
  final Widget showCreateHouseholdDialog;
  final Widget showJoinHouseholdDialog;

  const EmptyHouseholdsListPage({
    super.key,
    required this.showCreateHouseholdDialog,
    required this.showJoinHouseholdDialog,
  });

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: "Your households",
      showBackButton: false,
      body: BigIconPage(
        icon: const Icon(Icons.no_meeting_room, size: 200),
        title: "You have no household to manage, buddy.",
        text: "Join already existing household or create a "
            "new one and invite your friends. In case, you have any.",
        buttons: [
          _buildCreateHouseholdButton(context),
          _buildJoinHouseholdButton(context),
        ],
      ),
    );
  }

  Widget _buildCreateHouseholdButton(BuildContext context) {
    return FullWidthButton(
      icon: const Icon(Icons.domain_add),
      label: "Create a new household",
      alignment: Alignment.center,
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => showCreateHouseholdDialog,
        );
      },
    );
  }

  Widget _buildJoinHouseholdButton(BuildContext context) {
    return FullWidthButton(
        icon: const Icon(Icons.login),
        label: "Join an existing household",
        alignment: Alignment.center,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => showJoinHouseholdDialog,
          );
        });
  }
}
