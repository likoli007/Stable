import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'Task.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Task {
  @DocumentSerializer()
  final List<DocumentReference> assignees;
  DateTime? deadline;
  String description;
  bool isDone;
  String name;
  @DocumentReferenceConverter()
  DocumentReference? repeat;
  @DocumentSerializer()
  List<DocumentReference>? subtasks;

  Task({
    required this.assignees,
    this.deadline,
    required this.description,
    required this.isDone,
    required this.name,
    this.repeat,
    this.subtasks,
  });
}
