import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:get_it/get_it.dart';

class CorrectionsListBloc extends BlocBase {

  final _firestore = GetIt.I.get<FirestoreProvider>();

  @override
  void dispose() {
    super.dispose();
  }

  Stream<QuerySnapshot> correcionsList(String contoID) {
    return _firestore.getCorrectionsForConto(contoID);
  }
}