import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/user.dart';

class FirestoreProvider {
  final _firestore = Firestore.instance;

  Future<DocumentReference> addTurma(name, school) async{
    return  _firestore.collection("turmas").add({"name": name, "school": school});
  }

  Stream<QuerySnapshot> turmasList() {
    return _firestore.collection("turmas").snapshots();
  }

  Stream<QuerySnapshot> contosList(turmaId) {
    return _firestore.collection("contos").where("turma", isEqualTo: turmaId).snapshots();
  }

  //TODO Verificar uma forma de não efetuar duas requisições futuramente.
  DocumentReference addUserToDatabase(User user, reference) {
    _firestore.collection("users").document(reference).setData({"email": user.email, "name": user.name, "email":user.email, "type": user.type});
    return _firestore.collection("users").document(reference);
  }
}