import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';

class UserService {
  final DatabaseService<Inhabitant> _inhabitantRepository;

  const UserService(this._inhabitantRepository);

  Stream<List<Inhabitant>> getIhabitantsStream() =>
      _inhabitantRepository.observeDocuments();

  Future<Inhabitant?> getInhabitant(String id) async =>
      await _inhabitantRepository.getDocument(id); //TODO search only wanted id

  Stream<Inhabitant?> getInhabitantStream(String id) {
    return _inhabitantRepository.observeDocument(id);
  }

  Future<void> addHouseholdToInhabitant(
      {required String uid, required DocumentReference newRef}) async {
    Inhabitant? user = await _inhabitantRepository.getDocument(uid);

    if (user != null) {
      user.households.add(newRef);
      _inhabitantRepository.updateEntity(uid, user);
    }
  }

  void createInhabitantFromAuth({
    required String displayName,
    required String uid,
  }) async {
    Inhabitant newInhabitant = Inhabitant(name: displayName, surname: '');

    await _inhabitantRepository.updateEntity(uid, newInhabitant);
  }

  void createInhabitant({
    required String name,
    required String surname,
  }) async {
    DocumentReference defaultReference =
        FirebaseFirestore.instance.doc('users/defaultReference');

    await _inhabitantRepository.add(Inhabitant(
      name: name,
      surname: surname,
    ));
  }
}
