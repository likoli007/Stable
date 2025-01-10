import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'household.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Household {
  @JsonKey(includeToJson: false)
  String id;
  @DocumentReferenceConverter()
  DocumentReference? admin;
  @DocumentSerializer()
  late List<DocumentReference> inhabitants;
  String name;
  String groupId;
  @DocumentSerializer()
  final List<DocumentReference> tasks;
  @DocumentSerializer()
  final List<DocumentReference> taskHistory;

  Household({
    required this.id,
    required this.admin,
    this.inhabitants = const [],
    required this.name,
    required this.groupId,
    this.tasks = const [],
    this.taskHistory = const [],
  });

  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);
  Map<String, dynamic> toJson() => _$HouseholdToJson(this);
}
