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
      tasks: (json['tasks'] as List<dynamic>?)
              ?.map((e) => const DocumentSerializer()
                  .fromJson(e as DocumentReference<Object?>))
              .toList() ??
          const [],
      taskHistory: (json['taskHistory'] as List<dynamic>?)
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
      'tasks': instance.tasks.map(const DocumentSerializer().toJson).toList(),
      'taskHistory':
          instance.taskHistory.map(const DocumentSerializer().toJson).toList(),
    };
