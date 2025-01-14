import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';

import 'package:stable/common/widget/loading_future_builder.dart';
import 'package:stable/common/page/page_layout.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/page/household/share_household_page.dart';

class EditHouseholdPage extends StatefulWidget {
  final String householdReference;

  // TODO add edit household color
  // TODO add edit household icon (emoji picker?)

  EditHouseholdPage({Key? key, required this.householdReference})
      : super(key: key);

  @override
  _EditHouseholdPageState createState() => _EditHouseholdPageState();
}

class _EditHouseholdPageState extends State<EditHouseholdPage> {
  late TextEditingController _nameController;
  final HouseholdService _householdService = GetIt.instance<HouseholdService>();
  final InhabitantService _inhabitantService =
      GetIt.instance<InhabitantService>();

  List<String> _inhabitants = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadHousehold();
  }

  void _loadHousehold() async {
    Household? household =
        await _householdService.getHousehold(widget.householdReference);
    setState(() {
      _nameController.text = household?.name ?? 'Error occurred';
      _inhabitants = household?.inhabitants.map((e) => e.id).toList() ?? [];
    });
  }

  void _updateHousehold() {
    if (_nameController.text.isNotEmpty) {
      _householdService.updateHouseholdName(
          widget.householdReference, _nameController.text);
    }
    _householdService.updateHouseholdInhabitants(
        widget.householdReference, _inhabitants);
  }

  @override
  void dispose() {
    _updateHousehold();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Edit Household',
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShareHouseholdPage(
                householdReference: widget.householdReference,
              ),
            ),
          );
        },
        tooltip: 'Add Inhabitant',
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Household Name'),
          ),
          Expanded(
            child: ReorderableListView(
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final String item = _inhabitants.removeAt(oldIndex);
                  _inhabitants.insert(newIndex, item);
                });
              },
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
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _inhabitants.remove(inhabitant);
                        });
                      },
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
