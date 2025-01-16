import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:get_it/get_it.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/household/household.dart';
import 'package:stable/service/inhabitant_service.dart';
import 'package:uuid/uuid.dart';

import '../model/inhabitant/inhabitant.dart';

class HouseholdService {
  final DatabaseService<Household> _householdRepository;
  final Uuid _uuid = const Uuid();

  const HouseholdService(this._householdRepository);

  Stream<List<Household>> getHouseholdsStream() =>
      _householdRepository.observeDocuments();

  Stream<Household?> getHouseholdStream(String ref) =>
      _householdRepository.observeDocument(ref);

  Stream<List<Household>> getHouseholdsStreamByIds(
      List<DocumentReference> ids) {
    return _householdRepository.observeDocumentsByIds(ids);
  }

  Future<List<Household>> getUserHouseholds(Inhabitant user) async {
    return await _householdRepository.getDocumentsByIds(user.households);
  }

  Future<Household?> getHousehold(String id) =>
      _householdRepository.getDocument(id); //TODO search only wanted id

  Future<Household?> getHouseholdByGroupId(String groupId) async {
    return await _householdRepository.getDocumentByField('groupId', groupId);
  }

  // TODO addInhabitant(inhabitantId, householdId)

  // TODO removeInhabitant(inhabitantId, householdId)

  Future<void> removeTask(String householdId, String taskId) async {
    Household? household = await _householdRepository.getDocument(householdId);

    for (int i = 0; i < household!.tasks.length; i++) {
      if (household.tasks[i].toString() == taskId) {
        household.tasks.removeAt(i);
        _householdRepository.updateEntity(household.id, household);
        return;
      }
    }
  }

  Future<DocumentReference> createHousehold({
    required String userId,
    required String name,
  }) async {
    DocumentReference ref = FirebaseFirestore.instance.doc('User/$userId');

    String uuid = _uuid.v4();
    String groupId =
        sha256.convert(utf8.encode(uuid)).toString().substring(0, 8);

    DocumentReference newId = await _householdRepository.add(Household(
      id: 'placeholder',
      admin: ref,
      name: name,
      inhabitants: [ref],
      groupId: groupId,
    ));
    return newId;
  }

  Future<void> addTaskToHousehold(
      String household, DocumentReference taskRef) async {
    Household? targetHousehold = await getHousehold(household);
    if (targetHousehold != null) {
      targetHousehold.tasks.add(taskRef);
      _householdRepository.updateEntity(targetHousehold.id, targetHousehold);
    }
  }

  Future<List<DocumentReference>> getHouseholdInhabitants(
      String householdRef) async {
    Household? household = await _householdRepository.getDocument(householdRef);

    return household!.inhabitants;
  }

  Future<void> joinHouseholdByGroupId({
    required String groupId,
    required String userId,
  }) async {
    Household? targetHousehold = await getHouseholdByGroupId(groupId);
    if (targetHousehold == null) {
      throw Exception('No household found with this invite code.');
    }
    // Add inhabitant to inhabitants list of a household
    // TODO if inhabitant already in household give error
    DocumentReference userRef = FirebaseFirestore.instance.doc('User/$userId');
    targetHousehold.inhabitants.add(userRef);
    _householdRepository.updateEntity(targetHousehold.id, targetHousehold);

    // Add household to list of households of an inhabitant
    InhabitantService _userService = GetIt.instance<InhabitantService>();
    DocumentReference householdRef =
        FirebaseFirestore.instance.doc('Household/${targetHousehold.id}');
    _userService.addHouseholdToInhabitant(
      uid: userId,
      newRef: householdRef,
    );
  }

  Future<void> updateHouseholdHistory(
      String householdId, DocumentReference ref) async {
    Household? household = await getHousehold(householdId);
    if (household != null) {
      household.taskHistory.add(ref);
      await _householdRepository.updateEntity(householdId, household);
    }
  }

  Future<void> updateHouseholdName(String householdId, String newName) async {
    Household? household = await getHousehold(householdId);
    if (household != null) {
      household.name = newName;
      await _householdRepository.updateEntity(householdId, household);
    }
  }

  Future<void> updateHouseholdInhabitants(
      String householdId, List<String> newInhabitants) async {
    Household? household = await getHousehold(householdId);
    if (household != null) {
      household.inhabitants = newInhabitants
          .map((ref) => FirebaseFirestore.instance.doc('User/$ref'))
          .toList();
      await _householdRepository.updateEntity(householdId, household);
    }
  }

  Future<void> removeTaskFromHistory(
      String householdRef, String taskRef) async {
    Household? household = await getHousehold(householdRef);
    if (household != null) {
      DocumentReference ref = FirebaseFirestore.instance.doc('Task/${taskRef}');
      int index = household.taskHistory.indexOf(ref);
      household.taskHistory.removeAt(index);
      await _householdRepository.updateEntity(householdRef, household);
    }
  }
}
