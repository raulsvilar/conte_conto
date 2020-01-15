import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:get_it/get_it.dart';

class FavoritesBloc extends ContosListBlocBase {

  final _firestore = GetIt.I.get<FirestoreProvider>();

  setFavorite(List args) {
    _firestore.setFavorite(args[0], args[1]);
  }

  @override
  Stream<QuerySnapshot> contosList(userID, turmaId) {
    return _firestore.getFavorites(userID);
  }
}