import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/service/household_service.dart';

class JoinHouseholdPage extends StatefulWidget {
  const JoinHouseholdPage({Key? key}) : super(key: key);

  @override
  _JoinHouseholdPageState createState() => _JoinHouseholdPageState();
}

class _JoinHouseholdPageState extends State<JoinHouseholdPage> {
  final _householdService = GetIt.instance<HouseholdService>();

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageBody(
      title: 'Join Household',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: 'Household Code',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _focusNode.requestFocus();
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String uid = FirebaseAuth.instance.currentUser!.uid;
                _householdService.joinHouseholdByGroupId(
                  groupId: _controller.text,
                  userId: uid,
                );
              },
              child: const Text('Join Household'),
            ),
          ],
        ),
      ),
    );
  }
}
