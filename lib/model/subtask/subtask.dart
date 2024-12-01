import 'package:json_annotation/json_annotation.dart';

part 'subtask.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Subtask {
  @JsonKey(includeToJson: false)
  String id;

  String description;
  bool isDone;

  Subtask({
    required this.id,
    required this.description,
    required this.isDone,
  });

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskToJson(this);
}
