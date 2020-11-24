import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/models/help_material.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';
import 'package:quill_delta/quill_delta.dart';

class HelpEditorBloc extends BlocBase {
  final _firestore = GetIt.I.get<FirestoreProvider>();

  final _controllerLoaded = BehaviorSubject<bool>.seeded(false);

  Function(bool) get contoLoaded => _controllerLoaded.sink.add;

  Stream<bool> get isContoLoaded => _controllerLoaded.stream;

  saveDocument(String turmaID, String name, NotusDocument document) async {
    _firestore.addMaterialForTurma(
        turmaID, HelpMaterial.newHelpMaterial(name, jsonEncode(document)));
  }

  loadDocument(String materialID, String turmaID) async {
    contoLoaded(false);
    HelpMaterial material =
    await _firestore.getMaterial(turmaID, materialID);
    if (material != null) {
      if (material.content != null && material.content.isNotEmpty)
        return NotusDocument.fromJson(jsonDecode(material.content));
    }
    final Delta delta = Delta()..insert(DESCRIPTION_EMPTY_CONTO);
    return NotusDocument.fromDelta(delta);
  }

  @override
  void dispose() {
    _controllerLoaded.close();
    super.dispose();
  }
}
