import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';

class InhabitantService {
  final DatabaseService<Inhabitant> _inhabitantRepository;

  const InhabitantService(this._inhabitantRepository);

  Stream<List<Inhabitant>> getIhabitantsStream() =>
      _inhabitantRepository.observeDocuments();

  Future<Inhabitant?> getInhabitant(String id) async =>
      await _inhabitantRepository.getDocument(id); //TODO search only wanted id

  Stream<Inhabitant?> getInhabitantStream(String id) {
    return _inhabitantRepository.observeDocument(id);
  }

  Stream<List<Inhabitant>> getInhabitansStreamByIds(
      List<DocumentReference> refs) {
    return _inhabitantRepository.observeDocumentsByIds(refs);
  }

  Future<void> addHouseholdToInhabitant({
    required String uid,
    required DocumentReference newRef,
  }) async {
    Inhabitant? user = await _inhabitantRepository.getDocument(uid);

    if (user != null) {
      user.households.add(newRef);
      await _inhabitantRepository.updateEntity(uid, user);
    } else {
      throw Exception('Inhabitant not found for uid: $uid');
    }
  }

  Future<void> removeHouseholdFromInhabitant(
      {required String uid, required DocumentReference newRef}) async {
    Inhabitant? user = await _inhabitantRepository.getDocument(uid);

    if (user != null) {
      user.households.remove(newRef);
      _inhabitantRepository.updateEntity(uid, user);
    }
  }

  Future<List<Inhabitant>> getInhabitants(List<DocumentReference> refs) {
    return _inhabitantRepository.getDocumentsByIds(refs);
  }

  void createInhabitantFromAuth({
    required String displayName,
    required String uid,
  }) async {
    Inhabitant newInhabitant = Inhabitant(
        id: 'placeholder',
        name: displayName,
        profileColor:
            Colors.primaries[Random().nextInt(Colors.primaries.length)]);

    await _inhabitantRepository.updateEntity(uid, newInhabitant);
  }
}
