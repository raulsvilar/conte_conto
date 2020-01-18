import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/corrections_list_bloc.dart';
import 'package:conte_conto/src/models/correction.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

class CorrectionsListPage extends StatelessWidget {

  final String _contoID;

  CorrectionsListPage(this._contoID);

  final _bloc = BlocProvider.getBloc<CorrectionsListBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DESCRIPTION_CORRECTIONS),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bloc.correcionsList(_contoID),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        if (snapshot.data.documents.length > 0)
          return _buildList(context, snapshot.data.documents);
        else
          return Center(
            child: Text(DESCRIPTION_NO_CONTOS_IN_CLASS),
          );
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
    final record = Correction.fromSnapshot(data);
    return ListTile(
      title: Text("${record.datetime.toDate()}"),
      onTap: () => onTapCorrection(context, record.reference.documentID),
    );
  }

  void onTapCorrection(BuildContext context, String correctionID) {
    Navigator.of(context).pushNamed(DESCRIPTION_EDITOR_CORRECTIONS,
        arguments: [_contoID, correctionID]);
  }
}
