import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

abstract class ContosListBase<T extends ContosListBlocBase>
    extends StatelessWidget {
  final bloc = BlocProvider.getBloc<T>();
  final bool canCreateConto;
  final String title;
  final String turmaID;
  final bool withFab;

  ContosListBase(
      {this.title,
      this.canCreateConto = false,
      this.turmaID,
      this.withFab = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "Contos"),
        actions: appBarActions(context),
      ),
      floatingActionButton: StreamBuilder(
        stream: bloc.turma,
        builder: (_, snapshot) {
          if (withFab &&
              snapshot.hasData &&
              (turmaID?.isNotEmpty ??
                  false || (bloc.user.turmaID?.isNotEmpty ??
                  false))) {
            return FloatingActionButton(
              heroTag: "FloatContos",
              onPressed: () => onPressedFloatingActionButton(context),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            );
          } else
            return Container();
        },
      ),
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
      stream: bloc.contosList(
          bloc.user.reference.id, turmaID ?? bloc.user.turmaID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (snapshot.data.docs.length > 0)
          return buildList(context, snapshot.data.docs);
        else
          return Center(
            child: Text(DESCRIPTION_NO_CONTOS_IN_CLASS),
          );
      },
    );
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.separated(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return buildListItem(context, snapshot[index]);
        },
        separatorBuilder: (context, index) {
          return Divider(height: 4.0,);
        });
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Conto.fromSnapshot(data);
    return configItem(record);
  }

  ItemWithImageTitleSub configItem(Conto conto);

  onTapConto(List args) {
    Navigator.of(args[0]).pushNamed(DESCRIPTION_EDITOR_PAGE,
        arguments: [args[1], canCreateConto]);
  }
}
