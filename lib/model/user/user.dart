import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stable/database/util/document_reference_converter.dart';

part 'user.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class User {
  String name;
  String surname;
  String photo;

  User({
    required this.name,
    required this.surname,
    this.photo = "",
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
