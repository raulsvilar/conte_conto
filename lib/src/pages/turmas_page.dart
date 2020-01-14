import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';

class TurmasPage extends StatelessWidget {

  final _bloc = BlocProvider.getBloc<TurmasBloc>();

  TurmasPage() {
    _bloc.user = GetIt.I.get<User>().reference.documentID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Turmas"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) =>
            [
              PopupMenuItem(
                value: 1,
                child: Text("Sair"),
              )
            ],
            onSelected: (value) {
              switch(value) {
                case 1:
                  _bloc.logout()
                      .then((_) => Navigator.of(context)
                      .pushReplacementNamed(DESCRIPTION_LOGIN_PAGE));

              }
            },
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
          onPressed: () => _showDialogNovaTurma(context),
          tooltip: 'Adicionar',
          child: Icon(
            Icons.add,
            color: Colors.white,
          )
      ),
//      bottomNavigationBar: BottomNavigation(
//          items: [bottomItems.library, bottomItems.favorites, bottomItems.messages],
//          onTapCallback: (index) => {}),
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
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Turma.fromSnapshot(data);
    return ItemWithImageTitleSub(
        record.reference.documentID,
        record.name, false, _onTapTurma,
      subTitle: record.school,
    );
  }

  _showDialogNovaTurma(BuildContext ctx) {
    var _saveBtn = FlatButton(
      child: Text(DIALOG_BUTTON_SAVE),
      onPressed: () {
        _bloc.addTurma();
        Navigator.of(ctx).pop();
      },
    );
    var _cancelBtn = FlatButton(
      child: Text(DIALOG_BUTTON_CANCEL),
      onPressed: () => Navigator.pop(ctx),
    );
    return showDialog(
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DIALOG_NEW_CLASS),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: _turmaField(),
                ),
                _schoolField(),
              ],
            ),
          ),
          actions: <Widget>[
            _cancelBtn,
            _saveBtn,
          ],
        );
      },
    );
  }

  Widget _turmaField() {
    return StreamBuilder(
      stream: _bloc.turmaName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeTurma,
          decoration: InputDecoration(
            labelText: DESCRIPTION_CLASS_NAME,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }



  Widget _schoolField() {
    return StreamBuilder(
      stream: _bloc.schoolName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeSchool,
          decoration: InputDecoration(
            labelText: DESCRIPTION_SCHOOL_NAME,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  _onTapTurma(String turmaId, BuildContext context) {
    Navigator.of(context).pushNamed(DESCRIPTION_TEACHER_CONTOS_LIST_PAGE, arguments: [turmaId]);
  }
}
