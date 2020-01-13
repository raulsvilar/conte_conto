import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';

class EditorBloc extends BlocBase {

  final _firestore = GetIt.I.get<FirestoreProvider>();



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

  void saveDocument(contoID, document, Function onSaved, canCreate) {

    final contents = jsonEncode(document);
    if (canCreate)
      saveConto(contoID, contents)
          .then((_) {
            onSaved();
          });
    else
      saveCorrection(contoID, contents)
          .then((_) {
        onSaved();
      });
  }

  Future<NotusDocument> loadDocument(contoID) async {
    String content = await getContoContent(contoID).catchError((e) => "");
    if (content.isNotEmpty) {
      return NotusDocument.fromJson(jsonDecode(content));
    }
    final Delta delta = Delta()..insert(DESCRIPTION_EMPTY_CONTO);
    return NotusDocument.fromDelta(delta);
  }

  Future<void> saveCorrection(contoID, String contents) async {
    return await _firestore.saveContoCorrection(contoID, contents);
  }
}