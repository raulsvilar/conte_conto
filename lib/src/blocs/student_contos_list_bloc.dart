import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import 'contos_list_bloc.dart';

class StudentContosListBloc extends ContosListBlocBase {
  final _authentication = GetIt.I.get<Authentication>();

  final _contoNameController = BehaviorSubject<String>();

  Stream<String> get contoName =>
      _contoNameController.stream.transform(validateField);

  Function(String) get changeContoName => _contoNameController.sink.add;

  final _codeTurmaController = BehaviorSubject<String>();

  Stream<String> get codeTurma =>
      _codeTurmaController.stream.transform(validateField);

  Function(String) get changeCode => _codeTurmaController.sink.add;

  final _controllerLoading = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get outLoading => _controllerLoading.stream;

  @override
  Stream<QuerySnapshot> contosList(userID, turmaId) {
    return firestore.contosListForStudent(userID, turmaId);
  }

  setFavorite(String contoId, bool data) {
    firestore.setFavorite(contoId, data);
  }

  void addConto(turmaID, userID) async {
    String userName = await firestore.getUser(userID).then((user) => user.name);
    Conto conto = Conto.newConto(
      _contoNameController.value,
      userName,
      userID,
      turmaID: turmaID,
      teacherID: await firestore.getTeacherIDFromTurma(turmaID),
    );
    firestore.addConto(conto);
  }

  void enterTurma(userID, BuildContext context) async {
    _controllerLoading.add(true);
    await firestore
        .enterStudentOnTurma(_codeTurmaController.value, userID)
        .then((_) {
      Navigator.of(context).pop();
      user.turmaID = _codeTurmaController.value;
      changeTurma(_codeTurmaController.value);
    }).catchError((e) {
      _controllerLoading.add(false);
      _codeTurmaController.sink.addError(DESCRIPTION_ENTER_TURMA_ERROR);
    });
  }

  @override
  void dispose() {
    _contoNameController.close();
    _codeTurmaController.close();
    super.dispose();
  }

  Future<void> logout() async {
    GetIt.I.unregister<User>();
    return await _authentication.singOut();
  }
}
