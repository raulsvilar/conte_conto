import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/help_material.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';

class HelpMaterialListBloc extends BlocBase {
  final _firestore = GetIt.I.get<FirestoreProvider>();

  Stream<QuerySnapshot> getHelpMaterial(String turmaID) {
    try {
      return _firestore.getMaterials(turmaID);
    } catch(e) {
      return Stream.error(DESCRIPTION_DIALOG_ERROR);
    }
  }

  void addMaterial(String materialName, String turmaID) {
    HelpMaterial material = HelpMaterial.newHelpMaterial(materialName, "");
    _firestore.addMaterialForTurma(turmaID, material);
  }
}