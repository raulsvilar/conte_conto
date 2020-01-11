import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

abstract class ContosListBase<T extends ContosListBlocBase> extends StatelessWidget {

  final bloc = BlocProvider.getBloc<T>();

  final String turmaId;

  final bool editorMode;

  final String userId;

  ContosListBase(this.turmaId, {this.userId, this.editorMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contos"),
        actions: appBarActions(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onPressedFloatingActionButton(context),
        child: Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigation(bottomNavigationItems(),
              (index) => {}),
      body: buildBody(context),
    );
  }

  onPressedFloatingActionButton(BuildContext context);

  List<Widget> appBarActions(BuildContext context);

  List<bottomItems> bottomNavigationItems();

  bottomNavigationCallback(BuildContext context, namedRoute, args) {
    Navigator.of(context).pushReplacementNamed(namedRoute, arguments: args);
  }

  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.contosList(userId, turmaId),
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
    return configItem(record);
  }

  ItemWithImageTitleSub configItem(Conto conto);

  onTapConto(String contoID, BuildContext context) {
    Navigator.of(context).pushNamed(DESCRIPTION_EDITOR_PAGE, arguments: [contoID, editorMode]);
  }

}