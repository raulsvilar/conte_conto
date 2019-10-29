import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final _firestore = Firestore.instance;

  Future<DocumentReference>addTurma(name, school) async{
    return  _firestore.collection('turmas').add({'name': name, 'school': school});
  }

  Stream<QuerySnapshot> turmasList() {
    return _firestore.collection('turmas').snapshots();
  }

  Stream<QuerySnapshot> contosList(turma_id) {
    return _firestore.collection('contos').where('turma', isEqualTo: turma_id).snapshots();
  }

}