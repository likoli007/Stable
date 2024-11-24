part of 'package:stable/database/service/database_service.dart';

typedef DocumentDeserializer<T> = T Function(Map<String, dynamic> json);
typedef DocumentSerializer<T> = Map<String, dynamic> Function(T data);

T _deserializeJsonDocument<T>(DocumentSnapshot<Map<String, dynamic>> document,
    DocumentDeserializer<T> deserializer) {
  final json = document.data()!..['id'] = document.id;
  return deserializer(json);
}

Map<String, dynamic> _serializeJsonDocument<T>(
    T data, DocumentSerializer<T> serializer) {
  final json = serializer(data)..remove('id');
  return json;
}
