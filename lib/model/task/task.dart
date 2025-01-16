import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Task {
  @JsonKey(includeToJson: false)
  String id;
  @DocumentReferenceConverter()
  DocumentReference? assignee;
  @TimestampConverter()
  DateTime? deadline;
  String description;
  bool isDone;
  bool rotating;
  String name;

  @NullableIntConverter()
  int? repeat;

  @DocumentSerializer()
  List<DocumentReference>? subtasks;

  Task({
    required this.id,
    required this.assignee,
    this.deadline,
    required this.description,
    required this.isDone,
    required this.name,
    this.repeat,
    this.subtasks,
    required this.rotating,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
