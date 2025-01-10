// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subtask.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subtask _$SubtaskFromJson(Map<String, dynamic> json) => Subtask(
      id: json['id'] as String,
      description: json['description'] as String,
      isDone: json['isDone'] as bool,
      taskReference: const DocumentReferenceConverter()
          .fromJson(json['taskReference'] as DocumentReference<Object?>?),
    );

Map<String, dynamic> _$SubtaskToJson(Subtask instance) => <String, dynamic>{
      'taskReference':
          const DocumentReferenceConverter().toJson(instance.taskReference),
      'description': instance.description,
      'isDone': instance.isDone,
    };
