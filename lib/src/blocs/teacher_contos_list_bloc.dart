import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:get_it/get_it.dart';

class TeacherContosListBloc extends ContosListBlocBase {

  final _firestore = GetIt.I.get<FirestoreProvider>();


  setFavorite(String contoId, bool data) {
    _firestore.setFavorite(contoId, data);
  }

  @override
  Stream<QuerySnapshot> contosList(_, turmaId) {
    print(turmaId);
    return _firestore.contosListForTurma(turmaId);
  }

}