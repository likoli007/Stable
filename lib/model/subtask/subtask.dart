import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'subtask.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class SubTask {
  @JsonKey(includeToJson: false)
  String id;

  String description;
  bool isDone;

  SubTask({
    required this.id,
    required this.description,
    required this.isDone,
  });

  factory SubTask.fromJson(Map<String, dynamic> json) =>
      _$SubTaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubTaskToJson(this);
}
