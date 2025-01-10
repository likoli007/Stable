import 'package:flutter/material.dart';
import 'package:stable/common/widget/page_template.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/service/household_service.dart';
import 'package:get_it/get_it.dart';

class EditHouseholdPage extends StatefulWidget {
  final householdReference;

  EditHouseholdPage({Key? key, required this.householdReference})
      : super(key: key);

  @override
  _EditHouseholdPageState createState() => _EditHouseholdPageState();
}

class _EditHouseholdPageState extends State<EditHouseholdPage> {
  late TextEditingController _nameController;
  final HouseholdService _householdService = GetIt.instance<HouseholdService>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.household.name);
  }

  @override
  void dispose() {
    if (_nameController.text != widget.household.name) {
      _householdService.updateHouseholdName(
          widget.household.id, _nameController.text);
    }
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: widget.household.name,
      child: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'Household Name'),
          ),
          // TODO add edit household color
          // TODO add edit household icon (emoji picker?)
          // TODO add household members list (with remove member button)
          // TODO add add member button (show invite code and share it to other apps if on mobile)
        ],
      ),
    );
  }
}
