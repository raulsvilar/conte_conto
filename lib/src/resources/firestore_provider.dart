import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/user.dart';

class FirestoreProvider {
  final _firestore = Firestore.instance;

  Future<DocumentReference> addTurma(userID, name, school) async{
    return  _firestore.collection("users").document(userID).collection("turmas").add({"name": name, "school": school});
  }

  Stream<QuerySnapshot> turmasList(userID) {
    return _firestore.collection("users").document(userID).collection("turmas").snapshots();
  }

  Stream<QuerySnapshot> contosListForTurma(turmaId) {
    return _firestore.collection("contos").where("turma", isEqualTo: turmaId).snapshots();
  }

  Stream<QuerySnapshot> getFavorites(turmaId) {
    return _firestore.collection("contos").where("turma", isEqualTo: turmaId).where("favorited", isEqualTo: true).snapshots();
  }
  
  setFavorite(String contoId, bool data) {
    _firestore.collection("contos").document(contoId).updateData({"favorited": data});
  }

  createUser(User user, reference){
    _firestore.runTransaction((Transaction tx) async {
      await tx.set(_firestore.document("users/$reference"), user.toJson()).catchError((onError) => print("Erros aqui: $onError"));
    });
  }
}