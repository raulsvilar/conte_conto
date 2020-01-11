import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';

class EditorBloc extends BlocBase {

  final _firestore = FirestoreProvider();



  @override
  void dispose() {
    super.dispose();
  }

  Future<void> saveConto(String contoID, String contents) async{
    return await _firestore.saveConto(contoID, contents);
  }

  Future<String> getContoContent(contoID) async {
    return await _firestore.getContoContent(contoID)
        .then((value) => value == null ? "" : value);
  }
}