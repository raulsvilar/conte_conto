import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';

class TeacherContosListBloc extends ContosListBlocBase {
  setFavorite(String contoId, bool data) {
    firestore.setFavorite(contoId, data);
  }

  @override
  Stream<QuerySnapshot> contosList(_, turmaId) {
    return firestore.contosListForTurma(turmaId);
  }
}
