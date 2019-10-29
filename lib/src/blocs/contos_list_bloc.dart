import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';

class ContosListBloc extends BlocBase {

  final _firestore = FirestoreProvider();

  Stream<QuerySnapshot> contosList(turma_id) {
    return _firestore.contosList(turma_id);
  }
}