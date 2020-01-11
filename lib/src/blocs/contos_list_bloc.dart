import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:get_it/get_it.dart';

class ContosListBloc extends BlocBase {

  final _firestore = GetIt.I.get<FirestoreProvider>();

  Stream<QuerySnapshot> contosList(turmaId) {
    print(turmaId);
    return _firestore.contosListForTurma(turmaId);
  }

  setFavorite(String contoId, bool data) {
    _firestore.setFavorite(contoId, data);
  }

}