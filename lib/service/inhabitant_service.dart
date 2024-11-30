import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stable/database/service/database_service.dart';
import 'package:stable/model/inhabitant/inhabitant.dart';

class UserService {
  final DatabaseService<Inhabitant> _inhabitantRepository;

  const UserService(this._inhabitantRepository);

  Stream<List<Inhabitant>> getIhabitantsStream() =>
      _inhabitantRepository.observeDocuments();

  Future<List<Inhabitant>> getInhabitant(int id) =>
      _inhabitantRepository.getAllDocuments(); //TODO search only wanted id

  // TODO updateInhabitant(inhabitantId)

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
