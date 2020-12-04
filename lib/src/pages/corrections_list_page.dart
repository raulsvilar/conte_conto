import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/corrections_list_bloc.dart';
import 'package:conte_conto/src/models/correction.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        if (snapshot.data.docs.length > 0)
          return _buildList(context, snapshot.data.docs);
        else
          return Center(
            child: Text(DESCRIPTION_NO_CONTOS_IN_CLASS),
          );
      },
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
    final text = "Sem data";
    final record = Correction.fromSnapshot(data);
    final date = DateTime.fromMillisecondsSinceEpoch(
        record.datetime.millisecondsSinceEpoch);
    final DateFormat format = DateFormat('dd/mm/y HH:mm:ss');
    return ListTile(
      title: Text("${format.format(date) ?? text}"),
      onTap: () => onTapCorrection(context, record.reference.id),
    );
  }

  void onTapCorrection(BuildContext context, String correctionID) {
    Navigator.of(context).pushNamed(DESCRIPTION_EDITOR_CORRECTIONS,
        arguments: [_contoID, correctionID]);
  }
}
