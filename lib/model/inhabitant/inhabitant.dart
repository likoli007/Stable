import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';
part 'inhabitant.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Inhabitant {
  @JsonKey(includeToJson: false)
  String id;
  String name;
  @ColorConverter()
  Color profileColor;

  @DocumentSerializer()
  List<DocumentReference> households;

  Inhabitant({required this.id, required this.name, required this.profileColor})
      : households = [];

  factory Inhabitant.fromJson(Map<String, dynamic> json) =>
      _$InhabitantFromJson(json);
  Map<String, dynamic> toJson() => _$InhabitantToJson(this);
}
