import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:get_it/get_it.dart';

class TurmasPage extends StatelessWidget {
  final _bloc = BlocProvider.getBloc<TurmasBloc>();

  TurmasPage() {
    _bloc.user = GetIt.I.get<User>().reference.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Turmas"),
        actions: <Widget>[
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text("Sair"),
              )
            ],
            onSelected: (value) {
              switch (value) {
                case 1:
                  _bloc.logout().then(
                    (_) {
                      Navigator.of(context, rootNavigator: true)
                          .pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => LoginPage()),
                              (Route<dynamic> route) => false);
                    },
                  );
              }
            },
          )
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        heroTag: "FloatTurma",
        onPressed: () => _showDialogNovaTurma(context),
        tooltip: 'Adicionar',
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bloc.turmasList(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        return _buildList(context, snapshot.data.docs);
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
      itemID: record.reference.id,
      title: record.name,
      withFavorites: false,
      onTapCallback: _onTapTurma,
      onTapCallbackArgs: [context, record.reference.id, record.name],
      subTitle: record.school,
    );
  }

  _showDialogNovaTurma(BuildContext ctx) {
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
            FlatButton(
              child: Text(DIALOG_BUTTON_CANCEL),
              onPressed: () => Navigator.of(context).pop(),
            ),
            FlatButton(
              child: Text(DIALOG_BUTTON_SAVE),
              onPressed: () {
                _bloc.addTurma();
                Navigator.of(context).pop();
              },
            ),
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

  _onTapTurma(List args) {
    Navigator.of(args[0]).pushNamed(DESCRIPTION_TEACHER_CONTOS_LIST_PAGE,
        arguments: [args[1], args[2]]);
  }
}
