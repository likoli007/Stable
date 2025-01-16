import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';
import 'package:stable/ui/common/widget/builder/loading_stream_builder.dart';
import 'package:stable/ui/common/widget/dialog/confirmation_dialog.dart';
import 'package:stable/ui/common/widget/dialog/text_input_dialog.dart';
import 'package:stable/ui/common/widget/speed_dial/custom_speed_dial_child.dart';
import 'package:stable/ui/common/widget/speed_dial/speed_dials.dart';
import 'package:stable/ui/page/household/manage_household_inhabitants.dart';
import 'package:share_plus/share_plus.dart';

import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/ui/page/task/common_task_view.dart';
import 'package:stable/ui/page/household/household_task_history_page.dart';

class HouseholdPage extends StatefulWidget {
  // TODO add rotary task overview
  final Household household;

  HouseholdPage({super.key, required this.household});

  @override
  State<HouseholdPage> createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  late String _householdName;

  final _householdProvider = GetIt.instance<HouseholdService>();

  @override
  void initState() {
    super.initState();
    _householdName = widget.household.name;
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: _householdName,
      body: _buildHouseholdStream(),
      floatingActionButton: _buildSpeedDials(context),
    );
  }

  Widget _buildHouseholdStream() {
    return LoadingStreamBuilder<Household?>(
      stream: _householdProvider.getHouseholdStream(widget.household.id),
      builder: _buildTaskStream,
    );
  }

  Widget _buildTaskStream(BuildContext context, Household? data) {
    return CommonTaskView(
      household: data!,
      showAssignee: true,
      isFailedView: false,
    );
  }

  Widget _buildSpeedDials(BuildContext context) {
    return SpeedDials(
      icon: Icons.more_horiz,
      activeIcon: Icons.more_vert,
      children: [
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.add_task),
          label: 'Add a new task',
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          onTap: () => {},
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.cancel),
          label: 'View failed tasks',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HouseholdTaskHistoryPage(
                householdReference: widget.household.id,
              ),
            ),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.add_reaction),
          label: 'Invite your friend',
          onTap: () => showDialog(
            context: context,
            builder: (context) => _showInviteDialog(context),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.supervised_user_circle),
          label: 'Manage inhabitants',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ManageHouseholdInhabitants(
                householdReference: widget.household.id,
              ),
            ),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.drive_file_rename_outline_rounded),
          label: 'Rename',
          onTap: () => showDialog(
            context: context,
            builder: (context) => _showRenameHouseholdDialog(),
          ),
        ),
        CustomSpeedDialChild(
          context: context,
          icon: const Icon(Icons.logout),
          label: 'Leave',
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          onTap: () {}, //TODO dialog - are you sure?
        ),
      ],
    );
  }

  Widget _showInviteDialog(BuildContext context) {
    return ConfirmationDialog(
      title: 'Invite a friend',
      buttonText: 'Share',
      children: [
        const Text(
            'Share this invite code and tell your friends to join your household '
            'by clicking + button in the Households page and entering the code '
            'into "Join an existing household" dialog.'),
        const SizedBox(height: STANDARD_GAP),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                icon: const Icon(Icons.copy),
                onPressed: () => Clipboard.setData(
                    ClipboardData(text: widget.household.groupId))),
            SelectableText(
              widget.household.groupId,
              textScaler: const TextScaler.linear(HEADLINE_SCALER),
            ),
          ],
        ),
      ],
      onConfirm: () => Share.share(
        widget.household.groupId,
        subject: "Invite code for ${widget.household.name}",
      ),
    );
  }

  Widget _showRenameHouseholdDialog() {
    return TextInputDialog(
      title: 'Rename household',
      buttonText: 'Rename',
      textFieldInitialValue: widget.household.name,
      onSubmit: (name) async {
        _householdProvider.updateHouseholdName(widget.household.id, name);
        setState(() {
          _householdName = name;
        });
      },
    );
  }
}
