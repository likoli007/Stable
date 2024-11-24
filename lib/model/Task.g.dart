// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      assignees: (json['assignees'] as List<dynamic>)
          .map((e) => const DocumentSerializer()
              .fromJson(e as DocumentReference<Object?>))
          .toList(),
      deadline: json['deadline'] == null
          ? null
          : DateTime.parse(json['deadline'] as String),
      description: json['description'] as String,
      isDone: json['isDone'] as bool,
      name: json['name'] as String,
      repeat: const DocumentReferenceConverter()
          .fromJson(json['repeat'] as Map<String, dynamic>?),
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((e) => const DocumentSerializer()
              .fromJson(e as DocumentReference<Object?>))
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'assignees':
          instance.assignees.map(const DocumentSerializer().toJson).toList(),
      'deadline': instance.deadline?.toIso8601String(),
      'description': instance.description,
      'isDone': instance.isDone,
      'name': instance.name,
      'repeat': const DocumentReferenceConverter().toJson(instance.repeat),
      'subtasks':
          instance.subtasks?.map(const DocumentSerializer().toJson).toList(),
    };
