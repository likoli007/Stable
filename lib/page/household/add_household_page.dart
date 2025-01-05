import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/service/household_service.dart';
import 'package:stable/service/inhabitant_service.dart';

class AddHouseholdPage extends StatefulWidget {
  const AddHouseholdPage({Key? key}) : super(key: key);

  @override
  State<AddHouseholdPage> createState() => _AddHouseholdPageState();
}

class _AddHouseholdPageState extends State<AddHouseholdPage> {
  final _textController = TextEditingController();
  final _householdService = GetIt.instance.get<HouseholdService>();
  final _userService = GetIt.instance.get<UserService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Create Household'),
        ),
        body: _buildTextInput());
  }

  Padding _buildTextInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter the name of your Household...',
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              String uid = FirebaseAuth.instance.currentUser!.uid;
              String name = _textController.text;

              DocumentReference householdReference = await _householdService
                  .createHousehold(userId: uid, name: name);
              _userService.addHouseholdToInhabitant(
                  uid: uid, newRef: householdReference);
              _textController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add Household'),
          ),
        ],
      ),
    );
  }
}
