import 'package:conte_conto/src/blocs/student_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

import 'base/contos_list.dart';

class StudentContosList extends ContosListBase<StudentContosListBloc> {

  StudentContosList(userID, turmaID) : super(turmaID, userId: userID, canCreateConto: true) {
    bloc.changeTurma(turmaID);
  }

  @override
  Widget buildBody(BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.turma,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return super.buildBody(context);
          } else {
            return  _buildBodyNoClass(context);
          }
        }
    );
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
        bloc.addConto(turmaId, userId);
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
        bloc.enterTurma(userId, ctx);
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
                stream: bloc.outLoading,
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
      stream: bloc.contoName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeContoName,
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
      stream: bloc.codeTurma,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeCode,
          decoration: InputDecoration(
            labelText: DESCRIPTION_CODE,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
        conto.reference.documentID,
        conto.title,
        false,
        onTapConto);
  }

  @override
  List<bottomItems> bottomNavigationItems() {
    return [
      bottomItems.library,
      bottomItems.messages,
      bottomItems.help,
    ];
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    return <Widget>[
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
              bloc.logout()
                  .then((_) => Navigator.of(context)
                  .pushReplacementNamed(DESCRIPTION_LOGIN_PAGE));

          }
        },
      )
    ];
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    _showDialogNewConto(context);
  }

}