import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/household/household.dart';

class HouseholdService {
  final DatabaseService<Household> _householdRepository;

  const HouseholdService(this._householdRepository);

  Stream<List<Household>> getHouseholdsStream() =>
      _householdRepository.observeDocuments();

  Stream<List<Household>> getHouseholdsStreamByIds(
      List<DocumentReference> ids) {
    return _householdRepository.observeDocumentsByIds(ids);
  }

  Future<List<Household>> getHousehold(int id) =>
      _householdRepository.getAllDocuments(); //TODO search only wanted id

  // TODO addInhabitant(inhabitantId, householdId)

  // TODO removeInhabitant(inhabitantId, householdId)

  Future<DocumentReference> createHousehold({
    required String userId,
    required String name,
  }) async {
    DocumentReference defaultReference =
        FirebaseFirestore.instance.doc('users/defaultReference');

    DocumentReference ref = FirebaseFirestore.instance.doc('users/$userId');

    return await _householdRepository.add(Household(
      admin: ref,
      name: name,
    ));
  }
}
