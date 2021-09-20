import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as dart_path;
import 'package:quill_delta/quill_delta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';

class EditorBloc extends BlocBase {
  final _firestore = GetIt.I.get<FirestoreProvider>();
  Conto _conto;

  final _controllerFinished = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isContoFinished => _controllerFinished.stream;

  final _controllerCorrection = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isContoInCorrection => _controllerCorrection.stream;

  Stream<bool> get inEditionForStudent => Rx.combineLatest2(
      isContoInCorrection, isContoFinished, (e, p) => (e || p));

  Stream<bool> get inEditionForTeacher => isContoFinished;

  final _controllerLoaded = BehaviorSubject<bool>.seeded(false);

  Function(bool) get contoLoaded => _controllerLoaded.sink.add;

  Stream<bool> get isContoLoaded => _controllerLoaded.stream;

  @override
  void dispose() {
    _controllerFinished.close();
    _controllerLoaded.close();
    _controllerCorrection.close();
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

  void saveDocument(contoID, NotusDocument document, Function onSaved,
      Function onError, canCreate) async {
    try {
      List<String> images = [];
      for (LineNode node in document.root.children) {
        if (node.hasEmbed) {
          EmbedNode embedNode = node.children.single;
          EmbedAttribute attribute = embedNode.style.get(NotusAttribute.embed);
          String source = attribute.value['source'] as String;
          if (!source.contains("http")) {
            String url = await _firestore.uploadFile(source, contoID);
            attribute.value['source'] = url;
          }
          String newSource = attribute.value['source'];
          images.add(dart_path.basename(
              Uri.decodeFull(newSource.substring(0, newSource.indexOf('?')))));
          // Uri uri = Uri.dataFromString(attribute.value['source']);
          // images.add(uri.toFilePath());
        }
      }
      Map<String, Reference> imagesServer = await _firestore.listFiles(contoID);
      if (imagesServer != null) {
        for (String key in imagesServer.keys) {
          if (!images.contains(key)) {
            imagesServer[key].delete();
          }
        }
      }
      final contents = jsonEncode(document);
      if (canCreate)
        saveConto(contoID, contents).then(
          (_) => onSaved(),
        );
      else
        saveCorrection(contoID, contents).then(
          (_) => onSaved(),
        );
    } catch (e) {
      onError();
    }
  }

  Future<NotusDocument> setContoFinished(
      contoID, saveCallback, canCreate) async {
    if (_conto != null && !_conto.finished) {
      if (!canCreate)
        _firestore.setContoFinished(contoID);
      else
        _firestore.setSendContoForCorrection(contoID);
      saveCallback();
      return await loadDocument(contoID);
    }
  }

  Future<NotusDocument> loadDocument(contoID) async {
    contoLoaded(false);
    _conto = await _firestore.getConto(contoID);
    if (_conto != null) {
      _controllerFinished.sink.add(_conto.finished);
      _controllerCorrection.sink.add(_conto.sendedForCorrection);
      if (_conto.content != null && _conto.content.isNotEmpty)
        return NotusDocument.fromJson(jsonDecode(_conto.content));
    }
    final Delta delta = Delta()..insert(DESCRIPTION_EMPTY_CONTO);
    return NotusDocument.fromDelta(delta);
  }

  Future<void> saveCorrection(contoID, String contents) async {
    return await _firestore.saveContoCorrection(contoID, {"content": contents});
  }

  void publishConto(String contoID, Function onCompleted) async {
    await _firestore.publicarContoTurma(contoID);
    onCompleted();
  }
}
