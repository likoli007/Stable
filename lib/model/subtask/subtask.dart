import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'subtask.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Subtask {
  @JsonKey(includeToJson: false)
  String id;

  @DocumentReferenceConverter()
  DocumentReference? taskReference;

  String description;
  bool isDone;

  Subtask({
    required this.id,
    required this.description,
    required this.isDone,
    required this.taskReference,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskToJson(this);
}
