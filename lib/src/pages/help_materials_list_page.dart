import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/help_material_list_bloc.dart';
import 'package:conte_conto/src/models/help_material.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

class HelpMaterialListPage extends StatelessWidget {

  final String turmaID = GetIt.I.get<User>().turmaID;
  final HelpMaterialListBloc bloc = BlocProvider.getBloc<HelpMaterialListBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DESCRIPTION_MATERIALS),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bloc.getHelpMaterial(turmaID),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.docs.length > 0)
            return _buildList(context, snapshot.data.docs);
          else
            return Center(
              child: Text(DESCRIPTION_NO_CONTOS_IN_CLASS),
            );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.separated(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem(context, snapshot[index]);
        },
        separatorBuilder: (context, index) {
          return Divider();
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = HelpMaterial.fromSnapshot(data);
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.search),
      title: Text("${record.name}"),
      onTap: () => onTapMaterial(context, record.name, record.reference.id),
    );
  }

  void onTapMaterial(BuildContext context, String name, String materialID) {
    Navigator.of(context).pushNamed(DESCRIPTION_HELP_EDITOR_PAGE,
        arguments: [name, turmaID, materialID, true]);
  }

}