import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/common/widget/loading_future_builder.dart';
import 'package:stable/common/page/page_body.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';
import 'package:stable/service/inhabitant_service.dart';

class TaskAssigneePickPage extends StatelessWidget {
  TaskAssigneePickPage({Key? key, required this.users}) : super(key: key);

  final _inhabitantService = GetIt.instance<InhabitantService>();
  final List<DocumentReference> users;

  @override
  Widget build(BuildContext context) {
    return PageBody(
        title: "Assign Inhabitant", body: _buildInhabitantsFuture());
  }

  Widget _buildInhabitantsFuture() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick a User'),
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
