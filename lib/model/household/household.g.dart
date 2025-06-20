// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Household _$HouseholdFromJson(Map<String, dynamic> json) => Household(
      id: json['id'] as String,
      admin: const DocumentReferenceConverter()
          .fromJson(json['admin'] as DocumentReference<Object?>?),
      inhabitants: (json['inhabitants'] as List<dynamic>?)
              ?.map((e) => const DocumentSerializer()
                  .fromJson(e as DocumentReference<Object?>))
              .toList() ??
          const [],
      name: json['name'] as String,
      groupId: json['groupId'] as String,
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => const DocumentSerializer()
                  .fromJson(e as DocumentReference<Object?>))
              .toList() ??
          const [],
      failedTaskHistory: (json['failedTaskHistory'] as List<dynamic>?)
              ?.map((e) => const DocumentSerializer()
                  .fromJson(e as DocumentReference<Object?>))
              .toList() ??
          const [],
      doneTaskHistory: (json['doneTaskHistory'] as List<dynamic>?)
              ?.map((e) => const DocumentSerializer()
                  .fromJson(e as DocumentReference<Object?>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HouseholdToJson(Household instance) => <String, dynamic>{
      'admin': const DocumentReferenceConverter().toJson(instance.admin),
      'inhabitants':
          instance.inhabitants.map(const DocumentSerializer().toJson).toList(),
      'name': instance.name,
      'groupId': instance.groupId,
      'tasks': instance.tasks.map(const DocumentSerializer().toJson).toList(),
      'doneTaskHistory': instance.doneTaskHistory
          .map(const DocumentSerializer().toJson)
          .toList(),
      'failedTaskHistory': instance.failedTaskHistory
          .map(const DocumentSerializer().toJson)
          .toList(),
    };
