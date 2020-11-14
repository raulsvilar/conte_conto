import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/student_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/pages/login_page.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'base/contos_list.dart';

class StudentContosList extends ContosListBase<StudentContosListBloc> {
  StudentContosList() : super(canCreateConto: true, withFab: true) {
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

  @override
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    snapshot.sort((a, b) {
      if (b.data()['finished'])
        return -1;
      else if (b.data()['sendedForCorrection'])
        return -1;
      else
        return 1;
    });
    return super.buildList(context, snapshot.toList());
  }

  Future scan(BuildContext ctx) async {
    try {
      ScanResult scanResult = await BarcodeScanner.scan();
      String barcode = scanResult.rawContent;
      bloc.changeCode(barcode);
      bloc.enterTurma(bloc.user.reference.id, ctx);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        bloc.changeCode('The user did not grant the camera permission!');
      } else {
        bloc.changeCode('Unknown error: $e');
      }
    } on FormatException {
      bloc.changeCode(
          'null (User returned using the "back"-button before scanning anything. Result)');
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
                bloc.addConto(bloc.user.turmaID, bloc.user.reference.id);
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
                        bloc.enterTurma(bloc.user.reference.id, ctx);
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
        itemID: conto.reference.id,
        title: conto.title,
        withStatusTrailing: true,
        isContoFinished: conto.finished,
        isContoInCorrection: conto.sendedForCorrection,
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
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => LoginPage()),
                      (Route<dynamic> route) => false));
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
