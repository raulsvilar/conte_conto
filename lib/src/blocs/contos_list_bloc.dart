import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ContosListBlocBase extends BlocBase {

  Stream<QuerySnapshot> contosList(userID, turmaId);

}