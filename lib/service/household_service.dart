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

  Stream<List<Household>> getUserHouseholds(Inhabitant user) {
    return _householdRepository.observeDocumentsByIds(user.households);
  }

  Future<Household?> getHousehold(String id) =>
      _householdRepository.getDocument(id);

  Future<Household?> getHouseholdByGroupId(String groupId) async {
    return await _householdRepository.getDocumentByField('groupId', groupId);
  }

  Future<void> removeTask(String householdId, String taskId) async {
    final Household? household =
        await _householdRepository.getDocument(householdId);

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
    try {
      final DocumentReference ref =
          FirebaseFirestore.instance.doc('User/$userId');

      final String uuid = _uuid.v4();
      final String groupId =
          sha256.convert(utf8.encode(uuid)).toString().substring(0, 8);

      final DocumentReference newId = await _householdRepository.add(Household(
        id: 'placeholder',
        admin: ref,
        name: name,
        inhabitants: [ref],
        groupId: groupId,
      ));
      return newId;
    } catch (e) {
      throw Exception('Failed to create household: $e');
    }
  }

  Future<void> addTaskToHousehold(
      String household, DocumentReference taskRef) async {
    final Household? targetHousehold = await getHousehold(household);
    if (targetHousehold != null) {
      targetHousehold.tasks.add(taskRef);
      _householdRepository.updateEntity(targetHousehold.id, targetHousehold);
    }
  }

  Future<List<DocumentReference>> getHouseholdInhabitants(
      String householdRef) async {
    final Household? household =
        await _householdRepository.getDocument(householdRef);

    return household!.inhabitants;
  }

  Future<void> joinHouseholdByGroupId({
    required String groupId,
    required String userId,
  }) async {
    final Household? targetHousehold = await getHouseholdByGroupId(groupId);
    if (targetHousehold == null) {
      throw Exception('No household found with this invite code.');
    }

    // Add inhabitant to inhabitants list of a household
    final DocumentReference userRef =
        FirebaseFirestore.instance.doc('User/$userId');

    if (targetHousehold.inhabitants.contains(userRef)) {
      return;
    }

    targetHousehold.inhabitants.add(userRef);
    _householdRepository.updateEntity(targetHousehold.id, targetHousehold);

    // Add household to list of households of an inhabitant
    final InhabitantService inhabitantService =
        GetIt.instance<InhabitantService>();
    final DocumentReference householdRef =
        FirebaseFirestore.instance.doc('Household/${targetHousehold.id}');
    inhabitantService.addHouseholdToInhabitant(
      uid: userId,
      newRef: householdRef,
    );
  }

  Future<void> leaveHousehold({
    required String householdId,
    required String userId,
  }) async {
    final Household? targetHousehold = await getHousehold(householdId);
    if (targetHousehold == null) {
      throw Exception('No household found.');
    }

    final DocumentReference userRef =
        FirebaseFirestore.instance.doc('User/$userId');
    if (!targetHousehold.inhabitants.contains(userRef)) {
      throw Exception('User not found in household.');
    }

    // Remove inhabitant from inhabitants list of a household
    targetHousehold.inhabitants.remove(userRef);
    //if household is now empty, remove the household
    if (targetHousehold.inhabitants.isEmpty) {
      await _householdRepository.deleteDocument(targetHousehold.id);
    } else {
      await _householdRepository.updateEntity(
          targetHousehold.id, targetHousehold);
    }

    // Remove household from list of households of an inhabitant
    final InhabitantService inhabitantService =
        GetIt.instance<InhabitantService>();
    final DocumentReference householdRef =
        FirebaseFirestore.instance.doc('Household/${targetHousehold.id}');
    final Inhabitant? user = await inhabitantService.getInhabitant(userId);
    if (user == null) {
      throw Exception('User not found.');
    }
    if (!user.households.contains(householdRef)) {
      throw Exception('Household not found in user\'s list.');
    }
    await inhabitantService.removeHouseholdFromInhabitant(
      uid: userId,
      newRef: householdRef,
    );
  }

  Future<void> updateHouseholdHistory(
      String householdId, DocumentReference ref, bool isDone) async {
    final Household? household = await getHousehold(householdId);
    if (household != null) {
      if (isDone) {
        household.doneTaskHistory.add(ref);
      } else {
        household.failedTaskHistory.add(ref);
      }
      await _householdRepository.updateEntity(householdId, household);
    }
  }

  Future<void> updateHouseholdName(String householdId, String newName) async {
    final Household? household = await getHousehold(householdId);
    if (household != null) {
      household.name = newName;
      await _householdRepository.updateEntity(householdId, household);
    }
  }

  Future<void> updateHouseholdInhabitants(
      String householdId, List<String> newInhabitants) async {
    final Household? household = await getHousehold(householdId);
    if (household != null) {
      household.inhabitants = newInhabitants
          .map((ref) => FirebaseFirestore.instance.doc('User/$ref'))
          .toList();
      await _householdRepository.updateEntity(householdId, household);
    }
  }

  Future<void> removeTaskFromHistory(
      String householdRef, String taskRef) async {
    final Household? household = await getHousehold(householdRef);
    if (household != null) {
      DocumentReference ref = FirebaseFirestore.instance.doc('Task/$taskRef');
      int index = household.failedTaskHistory.indexOf(ref);
      household.failedTaskHistory.removeAt(index);
      await _householdRepository.updateEntity(householdRef, household);
    }
  }
}
