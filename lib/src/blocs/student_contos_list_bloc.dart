import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:conte_conto/src/utils/validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class StudentContosListBloc extends BlocBase with Validator{

  final _firestore = FirestoreProvider();

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



  Stream<QuerySnapshot> contosList(turmaId) {
    print(turmaId);
    return _firestore.contosListForTurma(turmaId);
  }

  setFavorite(String contoId, bool data) {
    _firestore.setFavorite(contoId, data);
  }

  void addConto(turmaID, userID) {
    Conto conto = Conto.newConto(
      title: _contoNameController.value,
      author: userID,
      turmaID: turmaID
    );
    _firestore.addConto(conto);
  }

  void enterTurma(userID, BuildContext context) async {
    _controllerLoading.add(true);
    await _firestore.enterStudentOnTurma(_codeTurmaController.value, userID)
        .then((_) => Navigator.of(context).pop())
        .catchError((e) {
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

}