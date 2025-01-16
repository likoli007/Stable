import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:stable/ui/common/util/shared_ui_constants.dart';

import 'package:stable/ui/common/widget/builder/loading_future_builder.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/ui/common/widget/dialog/confirmation_dialog.dart';

class ManageHouseholdInhabitants extends StatefulWidget {
  final String householdReference;

  const ManageHouseholdInhabitants(
      {super.key, required this.householdReference});

  @override
  ManageHouseholdInhabitantsState createState() =>
      ManageHouseholdInhabitantsState();
}

class ManageHouseholdInhabitantsState
    extends State<ManageHouseholdInhabitants> {
  List<String> _inhabitants = [];

  final HouseholdService _householdService = GetIt.instance<HouseholdService>();
  final InhabitantService _inhabitantService =
      GetIt.instance<InhabitantService>();

  @override
  void initState() {
    super.initState();
    _loadHousehold();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: 'Edit household',
      body: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.info),
              SizedBox(width: STANDARD_GAP),
              Expanded(
                child: Text(
                  "You can reorder all the inhabitants of your household. "
                  "This order will be used in the rotary tasks.",
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: STANDARD_GAP),
          Expanded(
            child: _buildInhabitantList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildInhabitantList(BuildContext context) {
    return ReorderableListView(
      onReorder: (int oldIndex, int newIndex) => _onReorder(oldIndex, newIndex),
      children: [
        for (final inhabitant in _inhabitants)
          ListTile(
            key: UniqueKey(),
            title: LoadingFutureBuilder<Inhabitant?>(
              future: _inhabitantService.getInhabitant(inhabitant),
              builder: (context, data) {
                return Text(data?.name ?? "Error occurred");
              },
            ),
            leading: const Icon(Icons.drag_indicator),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => _showRemoveDialog(context, inhabitant),
              ),
            ),
          )
      ],
    );
  }

  Widget _showRemoveDialog(BuildContext context, String inhabitantId) {
    return ConfirmationDialog(
      title: 'Remove from household',
      buttonText: 'Remove',
      confirmButtonForegroundColor: Colors.white,
      confirmButtonBackgroundColor: Colors.red,
      children: const [
        Text("Are you sure? You won't be friends anymore."),
        SizedBox(height: STANDARD_GAP),
        Icon(Icons.sentiment_dissatisfied, size: 100),
      ],
      onConfirm: () => _onConfirm(context, inhabitantId),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String item = _inhabitants.removeAt(oldIndex);
      _inhabitants.insert(newIndex, item);
    });
    _updateHousehold();
  }

  void _onConfirm(BuildContext context, String inhabitantId) async {
    try {
      await _householdService.leaveHousehold(
        householdId: widget.householdReference,
        userId: inhabitantId,
      );
      setState(() {
        _inhabitants.remove(inhabitantId);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bye bye.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void _loadHousehold() async {
    Household? household =
        await _householdService.getHousehold(widget.householdReference);
    setState(() {
      _inhabitants = household?.inhabitants.map((e) => e.id).toList() ?? [];
    });
  }

  void _updateHousehold() {
    _householdService.updateHouseholdInhabitants(
        widget.householdReference, _inhabitants);
  }
}
