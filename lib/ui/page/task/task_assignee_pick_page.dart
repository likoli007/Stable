import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/ui/common/widget/builder/loading_future_builder.dart';
import 'package:stable/ui/common/page/page_body.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/service/inhabitant_service.dart';

class TaskAssigneePickPage extends StatelessWidget {
  final List<DocumentReference> users;

  TaskAssigneePickPage({super.key, required this.users});

  final _inhabitantService = GetIt.instance<InhabitantService>();

  @override
  Widget build(BuildContext context) {
    return PageBody(
        title: "Assign Inhabitant", body: _buildInhabitantsFuture());
  }

  Widget _buildInhabitantsFuture() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick a User'),
      ),
      body: LoadingFutureBuilder(
          future: _inhabitantService.getInhabitants(users),
          builder: _buildInhabitantSelection),
    );
  }

  Widget _buildInhabitantSelection(
      BuildContext context, List<Inhabitant> inhabitants) {
    return ListView.builder(
      itemCount: inhabitants.length,
      itemBuilder: (context, index) {
        final name = inhabitants[index].name;
        return ListTile(
          title: Text(name),
          onTap: () {
            Navigator.pop(
                context, inhabitants[index]); // Navigate one step back
          },
        );
      },
    );
  }
}
