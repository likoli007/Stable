// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inhabitant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inhabitant _$InhabitantFromJson(Map<String, dynamic> json) => Inhabitant(
      id: json['id'] as String,
      name: json['name'] as String,
      profileColor: const ColorConverter()
          .fromJson((json['profileColor'] as num).toInt()),
    )..households = (json['households'] as List<dynamic>)
        .map((e) => const DocumentSerializer()
            .fromJson(e as DocumentReference<Object?>))
        .toList();

Map<String, dynamic> _$InhabitantToJson(Inhabitant instance) =>
    <String, dynamic>{
      'name': instance.name,
      'profileColor': const ColorConverter().toJson(instance.profileColor),
      'households':
          instance.households.map(const DocumentSerializer().toJson).toList(),
    };
