import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/models/correction.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zefyr/zefyr.dart';

class EditorCorrectionsBloc extends BlocBase {
  final _firestore = GetIt.I.get<FirestoreProvider>();

  final _controllerLoaded = BehaviorSubject<bool>.seeded(false);

  Function(bool) get contoLoaded => _controllerLoaded.sink.add;

  Stream<bool> get isContoLoaded => _controllerLoaded.stream;

  loadDocument(String correctionID, String contoID) async {
    contoLoaded(false);
    Correction correction =
        await _firestore.getCorrection(contoID, correctionID);
    if (correction != null) {
      if (correction.content != null && correction.content.isNotEmpty)
        return NotusDocument.fromJson(jsonDecode(correction.content));
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
