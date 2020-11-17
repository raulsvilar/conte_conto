import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/models/correction.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class FirestoreProvider {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  User get loggedUser => GetIt.I.get<User>();
  Future<String> uploadFile(String filePath, String contoID) async {
    File file = File(filePath);
    String extension = path.extension(file.path);
    try {
      var ref = _storage.ref(
          'uploads/${loggedUser.reference.id}/$contoID/${Uuid().v4()}$extension');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } on FirebaseException catch (e) {
      return e.code;
    }
  }

  Future<Map<String, Reference>> listFiles(String contoID) async {
    Map<String, Reference> lista = Map<String, Reference>();
    ListResult result = await _storage
        .ref('uploads/${loggedUser.reference.id}/$contoID')
        .listAll();
    result.items.forEach((Reference ref) {
      lista[ref.name] = ref;
    });
    return lista;
  }

  Future<DocumentReference> addTurma(Turma turma) {
    return _firestore.collection("turmas").add(turma.toJson());
  }

  Stream<QuerySnapshot> turmasList(userID) {
    return _firestore
        .collection("turmas")
        .where("owner", isEqualTo: userID)
        .orderBy("school")
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
    _firestore.collection("contos").doc(contoId).update({"favorited": data});
  }

  Future<User> createUser(User user, reference) async {
    await _firestore.runTransaction((Transaction tx) async {
      await tx.set(_firestore.doc("users/$reference"), user.toJson());
    });
    return await getUser(reference);
  }

  Future<User> getUser(String uid) async {
    return await _firestore
        .collection("users")
        .doc(uid)
        .get()
        .then((ds) => User.fromSnapshot(ds));
  }

  Future<String> getTeacherIDFromTurma(String turmaID) {
    return _firestore
        .collection("turmas")
        .doc(turmaID)
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
      DocumentReference userRef = _firestore.doc("users/$userID");
      DocumentReference turmaRef = _firestore.doc("turmas/$code");
      DocumentSnapshot userDS = await tx.get(userRef);
      DocumentSnapshot turmaDS = await tx.get(turmaRef);
      if (userDS.exists && turmaDS.exists) {
        List<String> newMembers = List.from(turmaDS.data()["members"]);
        newMembers.add(userID);
        tx.update(userRef, {"turmaID": code});
        tx.update(turmaRef, {"members": newMembers});
      } else
        throw (DESCRIPTION_ENTER_TURMA_ERROR);
    });
  }

  saveConto(String contoID, String data) {
    _firestore.collection("contos").doc(contoID).update({"content": data});
  }

  Future<String> getContoContent(contoID) async {
    return await _firestore
        .collection("contos")
        .doc(contoID)
        .get()
        .then((ds) => ds.data()["content"]);
  }

  saveContoCorrection(String contoID, Map<String, dynamic> contents) {
    contents["datetime"] = FieldValue.serverTimestamp();
    _firestore.runTransaction((Transaction tx) async {
      DocumentReference contoRef = _firestore.collection("contos").doc(contoID);
      await tx.update(contoRef, {"sendedForCorrection": false});
      //await tx.(contoRef, {"corrections": contents});
      contoRef.collection("corrections").add(contents);
    });
  }

  void setContoFinished(contoID) {
    _firestore.collection("contos").doc(contoID).update({"finished": true});
  }

  Future<Conto> getConto(contoID) async {
    return await _firestore
        .collection("contos")
        .doc(contoID)
        .get()
        .then((ds) => Conto.fromSnapshot(ds));
  }

  void setSendContoForCorrection(contoID) {
    _firestore
        .collection("contos")
        .doc(contoID)
        .update({"sendedForCorrection": true});
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
        .doc(turmaID)
        .update({"materials": materialContent});
  }

  Stream<QuerySnapshot> getMaterials(turmaID) {
    return _firestore
        .collection("turmas")
        .doc(turmaID)
        .collection("materials")
        .snapshots();
  }

  Stream<QuerySnapshot> getCorrectionsForConto(String contoID) {
    return _firestore
        .collection("contos")
        .doc(contoID)
        .collection("corrections")
        .snapshots();
  }

  Future<Correction> getCorrection(String contoID, String correctionID) async {
    return _firestore
        .collection("contos")
        .doc(contoID)
        .collection("corrections")
        .doc(correctionID)
        .get()
        .then((ds) => Correction.fromSnapshot(ds));
  }
}
