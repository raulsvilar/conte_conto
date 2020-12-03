import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';

class StudentsClassContosBloc {
  final FirestoreProvider _firestore = GetIt.I.get<FirestoreProvider>();

  User get user => GetIt.I.get<User>();

  Future<List<Conto>> contosList(String turmaID) async {
    if (turmaID.isNotEmpty) return await _firestore.getContoPublicados(turmaID);
    else throw(DESCRIPTION_DIALOG_ERROR);
  }
}
