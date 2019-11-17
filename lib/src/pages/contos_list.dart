import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class ContosList extends StatelessWidget {

  final _bloc = BlocProvider.getBloc<ContosListBloc>();
  final String _turmaId;

  ContosList(this._turmaId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
        bottomNavigationBar: BottomNavigation(
        [Items.library, Items.favorites, Items.messages],
            (index) => {}),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bloc.contosList(_turmaId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildListItem(context, snapshot[index]);
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Conto.fromSnapshot(data);
    print(record.toString());
    return ItemWithImageTitleSub(
      record.reference.documentID,
      record.title, record.author,
      true,
      _onTapConto,
      setFavoriteCallback:
      _setFavorite,
      isFavorited: record.isFavorited,
      callbackArg: [record.reference.documentID, !record.isFavorited]);
  }

  _onTapConto() {}

  _setFavorite(contoId, data) {
    _bloc.setFavorite(contoId, data);
  }

}