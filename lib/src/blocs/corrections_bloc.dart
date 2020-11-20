import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';

class CorrectionsBloc extends ContosListBlocBase {
  @override
  Stream<QuerySnapshot> contosList(userID, turmaId) {
    return firestore.contosListForStudent(userID, turmaId);
  }
}
