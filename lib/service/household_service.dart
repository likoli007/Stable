import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/household/household.dart';
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

  // TODO addInhabitant(inhabitantId, householdId)

  // TODO removeInhabitant(inhabitantId, householdId)

  Future<DocumentReference> createHousehold({
    required String userId,
    required String name,
  }) async {
    DocumentReference defaultReference =
        FirebaseFirestore.instance.doc('users/defaultReference');

    DocumentReference ref = FirebaseFirestore.instance.doc('users/$userId');

    String uuid = _uuid.v4();
    String groupId =
        sha256.convert(utf8.encode(uuid)).toString().substring(0, 8);

    DocumentReference newId = await _householdRepository.add(Household(
      id: 'placeholder',
      admin: ref,
      name: name,
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
}
