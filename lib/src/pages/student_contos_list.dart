import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/student_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

class StudentContosList extends StatelessWidget {

  final _bloc = BlocProvider.getBloc<StudentContosListBloc>();
  final String _turmaId;
  final _userID;

  StudentContosList(this._userID, this._turmaId) {
    _bloc.changeTurma(_turmaId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DESCRIPTION_APPBAR_TITLE_CONTOS_STUDENT),
      ),
      floatingActionButton: StreamBuilder<String>(
        stream: _bloc.turma,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () => _showDialogNewConto(context),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            );
          } else {
            return Container();
          }
        }
      ),
        bottomNavigationBar: BottomNavigation([
          Items.library,
          Items.favorites,
          Items.messages
        ], (index) => {}),
      body:
        StreamBuilder<String>(
          stream: _bloc.turma,
          builder: (_, snapshot) {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              return _buildBody(context);
            } else {
              return  _buildBodyNoClass(context);
            }
          }
        )
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _bloc.contosList(_userID, _turmaId),
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
      false,
      _onTapConto);
  }

  _onTapConto(_, BuildContext context) {
    Navigator.of(context).pushNamed(DESCRIPTION_EDITOR_PAGE);
  }

  _buildBodyNoClass(BuildContext context) {
    return InkWell(
      onTap: () => _showDialogEnterTurma(context),
      child: Center(
        child: Text(
          NO_CLASS_TEXT,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  _showDialogNewConto(BuildContext ctx) {
    var _saveBtn = FlatButton(
      child: Text(DIALOG_BUTTON_SAVE),
      onPressed: () {
        _bloc.addConto(_turmaId, _userID);
        Navigator.pop(ctx);
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
          title: Text(DIALOG_NEW_CONTO),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: _contoNameField(),
                ),
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

  _showDialogEnterTurma(BuildContext ctx) {
    var _enterBtn = FlatButton(
      child: Text(DIALOG_BUTTON_ENTER),
      onPressed: () {
        _bloc.enterTurma(_userID, ctx);
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
          title: Text(DIALOG_ENTER_CLASS),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: _codeTurmaField(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            _cancelBtn,
            StreamBuilder<Object>(
                stream: _bloc.outLoading,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data) {
                    return Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  }
                  else{
                    return _enterBtn;
                  }
                }
                )
          ],
        );
      },
    );
  }

  Widget _contoNameField() {
    return StreamBuilder(
      stream: _bloc.contoName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeContoName,
          decoration: InputDecoration(
            labelText: DESCRIPTION_CONTO_NAME,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget _codeTurmaField() {
    return StreamBuilder(
      stream: _bloc.codeTurma,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeCode,
          decoration: InputDecoration(
            labelText: DESCRIPTION_CODE,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

}