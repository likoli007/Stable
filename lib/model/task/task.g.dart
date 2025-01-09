// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      id: json['id'] as String,
      assignee: const DocumentReferenceConverter()
          .fromJson(json['assignee'] as DocumentReference<Object?>?),
      deadline: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['deadline'], const TimestampConverter().fromJson),
      description: json['description'] as String,
      isDone: json['isDone'] as bool,
      name: json['name'] as String,
      repeat: const DocumentReferenceConverter()
          .fromJson(json['repeat'] as DocumentReference<Object?>?),
      subtasks: (json['subtasks'] as List<dynamic>?)
          ?.map((e) => const DocumentSerializer()
              .fromJson(e as DocumentReference<Object?>))
          .toList(),
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'assignee': const DocumentReferenceConverter().toJson(instance.assignee),
      'deadline': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.deadline, const TimestampConverter().toJson),
      'description': instance.description,
      'isDone': instance.isDone,
      'name': instance.name,
      'repeat': const DocumentReferenceConverter().toJson(instance.repeat),
      'subtasks':
          instance.subtasks?.map(const DocumentSerializer().toJson).toList(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);
