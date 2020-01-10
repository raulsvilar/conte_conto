import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/models/user.dart';

class FirestoreProvider {
  final _firestore = Firestore.instance;

  Future<DocumentReference> addTurma(Turma turma) async{
    return  _firestore
        .collection("turmas")
        .add(turma.toJson());
  }

  Stream<QuerySnapshot> turmasList(userID) {
    return _firestore
        .collection("turmas")
        .where("owner", isEqualTo: userID)
        .snapshots();

  }

  Stream<QuerySnapshot> contosListForTurma(turmaId) {
    return _firestore
        .collection("contos")
        .where("turma", isEqualTo: turmaId)
        .snapshots();
  }

  Stream<QuerySnapshot> contosListForStudent(userID, turmaId) {
    return _firestore
        .collection("contos")
        .where("turmaID", isEqualTo: turmaId)
        .where("author", isEqualTo: userID)
        .snapshots();
  }

  Stream<QuerySnapshot> getFavorites(turmaId) {
    return _firestore
        .collection("contos")
        .where("turma", isEqualTo: turmaId)
        .where("favorited", isEqualTo: true)
        .snapshots();
  }
  
  setFavorite(String contoId, bool data) {
    _firestore
        .collection("contos")
        .document(contoId)
        .updateData({"favorited": data});
  }

  Future<DocumentSnapshot> createUser(User user, reference) async{
    await _firestore.runTransaction((Transaction tx) async {
      await tx.set(_firestore.document("users/$reference"), user.toJson())
          .catchError((onError) => print("Erros aqui: $onError"));
    });
    return await getUser(reference);
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    return await _firestore.collection("users").document(uid).get();
  }

  void addConto(Conto conto) {
    _firestore.collection("contos").add(conto.toJson());
  }

  Future<dynamic> enterStudentOnTurma(code, userID) async{
    return _firestore.runTransaction((Transaction tx) async {
      DocumentReference userRef = _firestore.document("users/$userID");
      DocumentReference turmaRef = _firestore.document("turmas/$code");
      DocumentSnapshot userDS = await tx.get(userRef);
      DocumentSnapshot turmaDS = await tx.get(turmaRef);
      print("${turmaRef.documentID} Existe: ${turmaDS.exists}");
      if (userDS.exists && turmaDS.exists) {
        List<String> newMembers = List.from(turmaDS.data["members"]);
        newMembers.add(userID);
        await tx.update(userRef, {"turmaID": code});
        await tx.update(turmaRef, {"members": newMembers});
      }
    });
  }
}