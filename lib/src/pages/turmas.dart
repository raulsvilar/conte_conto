import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';
import 'package:conte_conto/src/utils/constants.dart';

class TurmasPage extends StatefulWidget {
  @override
  _TurmasPageState createState() => _TurmasPageState();

}

class _TurmasPageState extends State<TurmasPage> {

  final _bloc = BlocProvider.getBloc<TurmasBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Turmas"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showDialogNovaTurma(context),
        tooltip: 'Adicionar',
        child: Icon(Icons.add)
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bloc.turmasList(),
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
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Turma.fromSnapshot(data);
    return ItemWithImageTitleSub(record.name, record.school);
  }

  _showDialogNovaTurma(BuildContext ctx) {

    var _saveBtn = FlatButton(
      child: Text(DIALOG_SAVE),
      onPressed: () {
        Navigator.pop(ctx);
      },
    );
    var _cancelBtn = FlatButton(
      child: Text(DIALOG_CANCEL),
      onPressed: () => Navigator.pop(ctx),
    );
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DIALOG_NEW_CLASS),
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _turmaField(_bloc),
                _schoolField(_bloc)
              ],
            ),
          ),
          actions: <Widget>[
            _cancelBtn,
            _saveBtn
          ],
          );
      }
    );
  }

  Widget _turmaField(TurmasBloc bloc) {
    return StreamBuilder(
      stream: bloc.turmaName,
      builder: (context, snapshot){
        return TextField(
          decoration: InputDecoration (
            hintText: DESCRIPTION_CLASS_NAME,
          ),
        );
      },
    );
  }

  Widget _schoolField(TurmasBloc bloc) {
    return StreamBuilder(
      stream: bloc.schoolName,
      builder: (context, snapshot) {
        return TextField(
          decoration: InputDecoration(
            hintText: DESCRIPTION_SCHOOL_NAME,
          ),
        );
      },
    );
  }
}