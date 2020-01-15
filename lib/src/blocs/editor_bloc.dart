import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';

class EditorBloc extends BlocBase {
  final _firestore = GetIt.I.get<FirestoreProvider>();
  Conto _conto;

  final _controllerFinished = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isContoFinished => _controllerFinished.stream;

  final _controllerLoaded = BehaviorSubject<bool>.seeded(false);
  Function(bool) get contoLoaded => _controllerLoaded.sink.add;
  Stream<bool> get isContoLoaded => _controllerLoaded.stream;

  @override
  void dispose() {
    _controllerFinished.close();
    _controllerLoaded.close();
    super.dispose();
  }

  Future<void> saveConto(String contoID, String contents) async {
    return await _firestore.saveConto(contoID, contents);
  }

  Future<String> getContoContent(contoID) async {
    return await _firestore
        .getContoContent(contoID)
        .then((value) => value == null ? "" : value);
  }

  void saveDocument(contoID, document, Function onSaved, canCreate) {
    final contents = jsonEncode(document);
    if (canCreate)
      saveConto(contoID, contents).then(
        (_) => onSaved(),
      );
    else
      saveCorrection(contoID, contents).then(
        (_) => onSaved(),
      );
  }

  Future<NotusDocument> setContoFinished(contoID) async {
    if(_conto != null && !_conto.finished) {
      _firestore.setContoFinished(contoID);
      return await loadDocument(contoID);
    }
  }

  Future<NotusDocument> loadDocument(contoID) async {
    _conto = await _firestore.getConto(contoID);
    if (_conto != null && _conto.content != null && _conto.content.isNotEmpty) {
      _controllerFinished.sink.add(_conto.finished);
      return NotusDocument.fromJson(jsonDecode(_conto.content));
    }
    final Delta delta = Delta()..insert(DESCRIPTION_EMPTY_CONTO);
    return NotusDocument.fromDelta(delta);
  }

  Future<void> saveCorrection(contoID, String contents) async {
    return await _firestore.saveContoCorrection(contoID, contents);
  }
}
