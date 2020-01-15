import 'package:barcode_scan/barcode_scan.dart';
import 'package:conte_conto/src/blocs/student_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base/contos_list.dart';

class StudentContosList extends ContosListBase<StudentContosListBloc> {

  StudentContosList()
      : super(canCreateConto: true, withFab: true) {
    bloc.changeTurma(bloc.user.turmaID);
    print(bloc.user.turmaID);
  }

  @override
  Widget buildBody(BuildContext context) {
    return StreamBuilder<String>(
        stream: bloc.turma,
        builder: (_, snapshot) {
          if (snapshot.hasData && snapshot.data.isNotEmpty) {
            return super.buildBody(context);
          } else {
            return _buildBodyNoClass(context);
          }
        });
  }

  Future scan(BuildContext ctx) async {
    try {
      String barcode = await BarcodeScanner.scan();
      bloc.changeCode(barcode);
      bloc.enterTurma(bloc.user.reference.documentID, ctx);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        bloc.changeCode('The user did not grant the camera permission!');
      } else {
        bloc.changeCode('Unknown error: $e');
      }
    } on FormatException{
      bloc.changeCode('null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      bloc.changeCode('Unknown error: $e');
    }
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
    return showDialog(
      useRootNavigator: false,
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
            FlatButton(
              child: Text(DIALOG_BUTTON_CANCEL),
              onPressed: () => Navigator.pop(ctx),
            ),
            FlatButton(
              child: Text(DIALOG_BUTTON_SAVE),
              onPressed: () {
                bloc.addConto(bloc.user.turmaID, bloc.user.reference.documentID);
                Navigator.pop(ctx);
              },
            )
          ],
        );
      },
    );
  }

  _showDialogEnterTurma(BuildContext ctx) {
    return showDialog(
      context: ctx,
      useRootNavigator: false,
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
            FlatButton(
              child: Text(DIALOG_BUTTON_CANCEL),
              onPressed: () => Navigator.pop(ctx),
            ),
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
                  } else {
                    return FlatButton(
                      child: Text(DIALOG_BUTTON_ENTER),
                      onPressed: () {
                        bloc.enterTurma(bloc.user.reference.documentID, ctx);
                      },
                    );
                  }
                })
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
          //controller: TextEditingController(text: snapshot.data),
          onChanged: bloc.changeCode,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => scan(context),
              icon: Icon(FontAwesomeIcons.qrcode),
            ),
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
        itemID: conto.reference.documentID,
        title: conto.title,
        withFavorites: false,
        onTapCallback: onTapConto);
  }

  @override
  List<Widget> appBarActions(BuildContext context) {
    return <Widget>[
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
              bloc.logout().then((_) =>
                  Navigator.of(context, rootNavigator: true).pushNamed("home"));
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
