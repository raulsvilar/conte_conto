import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/utils/validator.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

abstract class ContosListBlocBase extends BlocBase with Validator {
  final user = GetIt.I.get<User>();

  final _turmaController = BehaviorSubject<String>();

  Stream<String> get turma => _turmaController.stream.transform(validateField);

  Function(String) get changeTurma => _turmaController.sink.add;

  Stream<QuerySnapshot> contosList(userID, turmaId);

  @override
  void dispose() {
    _turmaController.close();
    super.dispose();
  }
}
