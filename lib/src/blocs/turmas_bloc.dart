import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/validator.dart';
import 'package:rxdart/rxdart.dart';

class TurmasBloc extends BlocBase with Validator{

  final _firestore = FirestoreProvider();

  final _schoolNameController = BehaviorSubject<String>();
  final _turmaNameController = BehaviorSubject<String>();

  Stream<String> get schoolName => _schoolNameController.stream.transform(validateField);
  Stream<String> get turmaName => _turmaNameController.stream.transform(validateField);


  Stream<QuerySnapshot> turmasList() {
    return _firestore.turmasList();
  }

  addTurma() {
   // _firestore.addTurma(name, school)
  }

  @override
  void dispose() {
    _turmaNameController?.close();
    _schoolNameController?.close();
    super.dispose();
  }

}