import 'package:cloud_firestore/cloud_firestore.dart';

part 'package:stable/database/util/serialization_definitions.dart';

// Database Service creates a common way to interface with firestore
class DatabaseService<T> {
  final CollectionReference<T> _collectionReference;

  DatabaseService(String collectionName,
      {required DocumentDeserializer<T> fromJson,
      required DocumentSerializer<T> toJson})
      : _collectionReference = FirebaseFirestore.instance
            .collection(collectionName)
            .withConverter(
              fromFirestore: (snapshot, _) =>
                  _deserializeJsonDocument(snapshot, fromJson),
              toFirestore: (value, _) => _serializeJsonDocument(value, toJson),
            );

  // TODO: add relevant functions as app is built

  Future<void> deleteDocument(String id) async {
    await _collectionReference.doc(id).delete();
  }

  Future<DocumentReference> add(T data) async {
    return await _collectionReference.add(data);
  }

  Future<void> updateEntity(String id, T newEntity) async {
    await _collectionReference.doc(id).set(newEntity);
  }

  Future<void> updateDocument(String id, Map<String, dynamic> fields) async {
    await _collectionReference.doc(id).update(fields);
  }

  Future<List<T>> getAllDocuments() async {
    final documentsSnapshot = await _collectionReference.get();
    return _mapQuerySnapshotToData(documentsSnapshot);
  }

  Future<List<T>> getDocumentsByIds(List<DocumentReference>? refs) async {
    List<T> result = [];
    if (refs != null) {
      final documentData = await _collectionReference
          .where(FieldPath.documentId, whereIn: refs)
          .get();
      result = documentData.docs
          .map((documentSnapshot) => documentSnapshot.data())
          .toList();
    }
    return result;
  }

  Stream<T?> observeDocument(String id) {
    return _collectionReference
        .doc(id)
        .snapshots()
        .map((documentSnapshot) => documentSnapshot.data());
  }

  Stream<List<T>> observeDocumentsByIds(List<DocumentReference>? refs) {
    if (refs == null || refs.isEmpty) {
      return Stream.value([]);
    }

    return _collectionReference
        .where(FieldPath.documentId, whereIn: refs)
        .snapshots()
        .map(_mapQuerySnapshotToData);
  }

  Future<T?> getDocument(String id) async {
    final documentData = await _collectionReference.doc(id).get();
    return documentData.data();
  }

  List<T> _mapQuerySnapshotToData(QuerySnapshot<T> snapshot) {
    return snapshot.docs
        .map((documentSnapshot) => documentSnapshot.data())
        .toList();
  }

  Future<DocumentReference> setOrUpdate(T newEntity, String entityId) async {
    if (entityId.isNotEmpty) {
      await updateEntity(entityId, newEntity);
      return _collectionReference.doc(entityId);
    } else {
      return add(newEntity);
    }
  }

  Stream<List<T>> observeDocuments() {
    return _collectionReference.snapshots().map(_mapQuerySnapshotToData);
  }

  Future<T?> getDocumentByField(String fieldName, dynamic value) async {
    QuerySnapshot<T> querySnapshot = await _collectionReference
        .where(fieldName, isEqualTo: value)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data();
    } else {
      return null;
    }
  }
}
