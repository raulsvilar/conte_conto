import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class ContosListBase<T extends ContosListBlocBase> extends StatelessWidget {

  final bloc = BlocProvider.getBloc<T>();
  final bool canCreateConto;
  final String title;
  final String turmaID;
  final bool withFab;
  final user = GetIt.I.get<User>();

  ContosListBase({this.title, this.canCreateConto = false, this.turmaID, this.withFab = false});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "Contos"),
        actions: appBarActions(context),
      ),
      floatingActionButton: withFab ? FloatingActionButton(
        heroTag: "FloatContos",
        onPressed: () => onPressedFloatingActionButton(context),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ) : null,
      body: buildBody(context),
    );
  }

  onPressedFloatingActionButton(BuildContext context);

  List<Widget> appBarActions(BuildContext context);

  bottomNavigationCallback(BuildContext context, namedRoute, args) {
    Navigator.of(context).pushReplacementNamed(namedRoute, arguments: args);
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.contosList(user.reference.documentID, turmaID),
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
    return configItem(record);
  }

  ItemWithImageTitleSub configItem(Conto conto);

  onTapConto(List args) {
    Navigator.of(args[0]).pushNamed(DESCRIPTION_EDITOR_PAGE, arguments: [args[1], canCreateConto]);
  }

}