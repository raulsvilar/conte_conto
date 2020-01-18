import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:rxdart/rxdart.dart';

class TeacherContosListBloc extends ContosListBlocBase {
  final _materialController = BehaviorSubject<String>();

  Stream<String> get materialName =>
      _materialController.stream.transform(validateField);

  Function(String) get changeMaterialName => _materialController.sink.add;

  setFavorite(String contoId, bool data) {
    firestore.setFavorite(contoId, data);
  }

  @override
  Stream<QuerySnapshot> contosList(_, turmaId) {
    return firestore.contosListForTurma(turmaId);
  }

  @override
  void dispose() {
    _materialController.close();
    super.dispose();
  }
}
