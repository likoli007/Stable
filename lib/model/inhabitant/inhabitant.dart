import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'inhabitant.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Inhabitant {
  String name;
  String surname;
  String photo;

  Inhabitant({
    required this.name,
    required this.surname,
    this.photo = "", // TODO change to default photo
  });

  factory Inhabitant.fromJson(Map<String, dynamic> json) =>
      _$InhabitantFromJson(json);
  Map<String, dynamic> toJson() => _$InhabitantToJson(this);
}
