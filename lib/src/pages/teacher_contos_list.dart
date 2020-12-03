import 'package:conte_conto/src/blocs/teacher_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TeacherContosList extends ContosListBase<TeacherContosListBloc> {
  TeacherContosList(turmaID, turmaName)
      : super(withFab: true, title: turmaName, turmaID: turmaID) {
    bloc.changeTurma(turmaID);
  }

  _setFavorite(List args) {
    bloc.setFavorite(args[0], args[1]);
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
      itemID: conto.reference.id,
      title: conto.title,
      withFavorites: true,
      onTapCallback: onTapConto,
      favoriteCallback: _setFavorite,
      subTitle: conto.author,
      isFavorited: conto.isFavorited,
      favoriteCallbackArgs: [conto.reference.id, !conto.isFavorited],
    );
  }

  @override
  List<Widget> appBarActions(context) {
    return [
      Builder(
        builder: (_) => IconButton(
          icon: Icon(FontAwesomeIcons.qrcode),
          onPressed: () => showQRDialog(context),
        ),
      ),
    ];
  }

  showQRDialog(BuildContext context) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return showDialog(
      useRootNavigator: false,
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          DESCRIPTION_CLASS_CODE,
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          Container(
            width: 0.5 * bodyHeight,
            height: 0.5 * bodyHeight,
            child: QrImage(
              data: turmaID,
              errorStateBuilder: (ctx, err) {
                return Text("[QR] ERROR - $err");
              },
            ),
          ),
          Text(
            turmaID,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    return _showDialogNewMaterial(context);
  }

  _showDialogNewMaterial(BuildContext ctx) {
    return showDialog(
      useRootNavigator: false,
      context: ctx,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DIALOG_NEW_MATERIAL),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: _materialNameField(),
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
                Navigator.pop(ctx);
                Navigator.of(context)
                    .pushNamed(DESCRIPTION_HELP_EDITOR_PAGE, arguments: [bloc.helpName, turmaID, null, false]);
              },
            )
          ],
        );
      },
    );
  }

  _materialNameField() {
    return StreamBuilder(
      stream: bloc.materialName,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeMaterialName,
          decoration: InputDecoration(
            labelText: DESCRIPTION_NAME,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }
}
