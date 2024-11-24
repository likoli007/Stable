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
    implements JsonConverter<DocumentReference?, Map<String, dynamic>?> {
  const DocumentReferenceConverter();

  @override
  DocumentReference? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return FirebaseFirestore.instance.doc(json['path'] as String);
  }

  @override
  Map<String, dynamic>? toJson(DocumentReference? docRef) {
    if (docRef == null) return null;
    return {'path': docRef.path};
  }
}
