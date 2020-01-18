import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/models/correction.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/models/user.dart';

class FirestoreProvider {
  final _firestore = Firestore.instance;

  Future<DocumentReference> addTurma(Turma turma) {
    return _firestore.collection("turmas").add(turma.toJson());
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
        .where("turmaID", isEqualTo: turmaId)
        .where("sendedForCorrection", isEqualTo: true)
        .snapshots();
  }

  Stream<QuerySnapshot> contosListForStudent(userID, turmaId) {
    return _firestore
        .collection("contos")
        .where("turmaID", isEqualTo: turmaId)
        .where("owner", isEqualTo: userID)
        .snapshots();
  }

  Stream<QuerySnapshot> getFavorites(String userId) {
    return _firestore
        .collection("contos")
        .where("teacherID", isEqualTo: userId)
        .where("favorited", isEqualTo: true)
        .snapshots();
  }

  setFavorite(String contoId, bool data) {
    _firestore
        .collection("contos")
        .document(contoId)
        .updateData({"favorited": data});
  }

  Future<User> createUser(User user, reference) async {
    await _firestore.runTransaction((Transaction tx) async {
      await tx.set(_firestore.document("users/$reference"), user.toJson());
    });
    return await getUser(reference);
  }

  Future<User> getUser(String uid) async {
    return await _firestore
        .collection("users")
        .document(uid)
        .get()
        .then((ds) => User.fromSnapshot(ds));
  }

  Future<String> getTeacherIDFromTurma(String turmaID) {
    return _firestore
        .collection("turmas")
        .document(turmaID)
        .get()
        .then((ds) => Turma.fromSnapshot(ds).owner);
  }

  void addConto(Conto conto) {
    Map<String, dynamic> data = conto.toJson();
    data["creationDate"] = FieldValue.serverTimestamp();
    _firestore.collection("contos").add(data);
  }

  Future<dynamic> enterStudentOnTurma(code, userID) async {
    return _firestore.runTransaction((Transaction tx) async {
      DocumentReference userRef = _firestore.document("users/$userID");
      DocumentReference turmaRef = _firestore.document("turmas/$code");
      DocumentSnapshot userDS = await tx.get(userRef);
      DocumentSnapshot turmaDS = await tx.get(turmaRef);
      if (userDS.exists && turmaDS.exists) {
        List<String> newMembers = List.from(turmaDS.data["members"]);
        newMembers.add(userID);
        await tx.update(userRef, {"turmaID": code});
        await tx.update(turmaRef, {"members": newMembers});
      }
    });
  }

  saveConto(String contoID, String data) {
    _firestore
        .collection("contos")
        .document(contoID)
        .updateData({"content": data});
  }

  Future<String> getContoContent(contoID) async {
    return await _firestore
        .collection("contos")
        .document(contoID)
        .get()
        .then((ds) => ds.data["content"]);
  }

  saveContoCorrection(String contoID, Map<String, dynamic> contents) {
    contents["datetime"] = FieldValue.serverTimestamp();
    _firestore.runTransaction((Transaction tx) async {
      DocumentReference contoRef =
          _firestore.collection("contos").document(contoID);
      await tx.update(contoRef, {"sendedForCorrection": false});
      //await tx.(contoRef, {"corrections": contents});
      contoRef.collection("corrections").add(contents);
    });
  }

  void setContoFinished(contoID) {
    _firestore
        .collection("contos")
        .document(contoID)
        .updateData({"finished": true});
  }

  Future<Conto> getConto(contoID) async {
    return await _firestore
        .collection("contos")
        .document(contoID)
        .get()
        .then((ds) => Conto.fromSnapshot(ds));
  }

  void setSendContoForCorrection(contoID) {
    _firestore
        .collection("contos")
        .document(contoID)
        .updateData({"sendedForCorrection": true});
  }

  Stream<QuerySnapshot> finishedContosListForTurma(turmaId) {
    return _firestore
        .collection("contos")
        .where("turmaID", isEqualTo: turmaId)
        .where("finished", isEqualTo: true)
        .snapshots();
  }

  Future<void> addMaterialForTurma(
      String turmaID, String userID, Map<String, dynamic> materialContent) {
    return _firestore
        .collection("turmas")
        .document(turmaID)
        .updateData({"materials": materialContent});
  }

  Stream<QuerySnapshot> getMaterials(turmaID) {
    return _firestore
        .collection("turmas")
        .document(turmaID)
        .collection("materials")
        .snapshots();
  }

  Stream<QuerySnapshot> getCorrectionsForConto(String contoID) {
    return _firestore
        .collection("contos")
        .document(contoID)
        .collection("corrections")
        .snapshots();
  }

  Future<Correction> getCorrection(String contoID, String correctionID) async {
    return _firestore
        .collection("contos")
        .document(contoID)
        .collection("corrections")
        .document(correctionID)
        .get()
        .then((ds) => Correction.fromSnapshot(ds));
  }
}
