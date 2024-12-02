import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'task.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Task {
  @JsonKey(includeToJson: false)
  String id;
  @DocumentSerializer()
  final List<DocumentReference> assignees;
  @TimestampConverter()
  DateTime? deadline;
  String description;
  bool isDone;
  String name;
  @DocumentReferenceConverter()
  DocumentReference? repeat;
  @DocumentSerializer()
  List<DocumentReference>? subtasks;

  Task({
    required this.id,
    required this.assignees,
    this.deadline,
    required this.description,
    required this.isDone,
    required this.name,
    this.repeat,
    this.subtasks,
  });

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

//TODO: find it its own place independent of task
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
