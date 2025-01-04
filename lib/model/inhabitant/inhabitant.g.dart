// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inhabitant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inhabitant _$InhabitantFromJson(Map<String, dynamic> json) => Inhabitant(
      name: json['name'] as String,
      surname: json['surname'] as String,
      photo: json['photo'] as String? ?? "",
    )..households =
        (json['households'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$InhabitantToJson(Inhabitant instance) =>
    <String, dynamic>{
      'name': instance.name,
      'surname': instance.surname,
      'photo': instance.photo,
      'households': instance.households,
    };
