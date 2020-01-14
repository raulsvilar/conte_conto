import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/validator.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class TurmasBloc extends BlocBase with Validator {
  final _firestore =  GetIt.I.get<FirestoreProvider>();
  final _authentication = GetIt.I.get<Authentication>();
  String _userUid;

  set user(String uid) {
    _userUid = uid;
  }

  final _schoolNameController = BehaviorSubject<String>();
  final _turmaNameController = BehaviorSubject<String>();

  Stream<String> get schoolName =>
      _schoolNameController.stream.transform(validateField);
  Stream<String> get turmaName =>
      _turmaNameController.stream.transform(validateField);

  Function(String) get changeSchool => _schoolNameController.sink.add;
  Function(String) get changeTurma => _turmaNameController.sink.add;

  Stream<QuerySnapshot> turmasList() {
    return _firestore.turmasList(_userUid);
  }

  addTurma() {
    if (_schoolNameController?.value != null &&
        _turmaNameController?.value != null) {
      _firestore.addTurma(Turma.newTurma(
          _turmaNameController?.value,
          _schoolNameController?.value,
          _userUid)
      );
    }
  }

  @override
  void dispose() {
    _turmaNameController?.close();
    _schoolNameController?.close();
    super.dispose();
  }

  Future<void> logout() async{
    GetIt.I.unregister<User>();
    return await _authentication.singOut();
  }
}
