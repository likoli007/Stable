import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

class DocumentSerializer
    implements JsonConverter<DocumentReference, DocumentReference> {
  const DocumentSerializer();

  @override
  DocumentReference fromJson(DocumentReference docRef) => docRef;

  @override
  DocumentReference toJson(DocumentReference docRef) => docRef;
}

class DocumentReferenceConverter
    implements JsonConverter<DocumentReference?, DocumentReference?> {
  const DocumentReferenceConverter();

  @override
  DocumentReference? fromJson(DocumentReference? docRef) => docRef;

  @override
  DocumentReference? toJson(DocumentReference? docRef) => docRef;
}

class DocumentReferenceConverterNonNull
    implements JsonConverter<DocumentReference, DocumentReference> {
  const DocumentReferenceConverterNonNull();

  @override
  DocumentReference fromJson(DocumentReference docRef) => docRef;

  @override
  DocumentReference toJson(DocumentReference docRef) => docRef;
}

class NullableIntConverter implements JsonConverter<int?, int?> {
  const NullableIntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is String) {
      return int.tryParse(json);
    }
    throw ArgumentError('Invalid type for nullable int: $json');
  }

  @override
  int? toJson(int? value) {
    return value;
  }
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) {
    return Color(json);
  }

  @override
  int toJson(Color object) {
    return object.value;
  }
}
