import 'package:conte_conto/src/blocs/teacher_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class TeacherContosList extends ContosListBase<TeacherContosListBloc> {
  TeacherContosList(turmaID, turmaName)
      : super(title: turmaName, turmaID: turmaID);

  _setFavorite(List args) {
    bloc.setFavorite(args[0], args[1]);
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
        itemID: conto.reference.documentID,
        title: conto.title,
        withFavorites: true,
        onTapCallback: onTapConto,
        favoriteCallback: _setFavorite,
        subTitle: conto.author,
        isFavorited: conto.isFavorited,
        favoriteCallbackArgs: [conto.reference.documentID, !conto.isFavorited]);
  }

  @override
  List<Widget> appBarActions(context) {
    return null;
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    // TODO: implement onPressedFloatingActionButton
    return null;
  }
}
