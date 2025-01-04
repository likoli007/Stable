import 'package:json_annotation/json_annotation.dart';
part 'inhabitant.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: true)
class Inhabitant {
  String name;
  String surname;
  String photo;
  List<String> households;

  Inhabitant({
    required this.name,
    required this.surname,
    this.photo = "", // TODO change to default photo
  }) : households = [];

  factory Inhabitant.fromJson(Map<String, dynamic> json) =>
      _$InhabitantFromJson(json);
  Map<String, dynamic> toJson() => _$InhabitantToJson(this);
}
