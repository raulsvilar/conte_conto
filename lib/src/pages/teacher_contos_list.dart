import 'package:conte_conto/src/blocs/teacher_contos_list_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class TeacherContosList extends ContosListBase<TeacherContosListBloc> {

  TeacherContosList(turmaID) : super(turmaID:turmaID);

  _setFavorite(contoId, data) {
    bloc.setFavorite(contoId, data);
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
        conto.reference.documentID,
        conto.title,
        true,
        onTapConto,
        setFavoriteCallback: _setFavorite,
        subTitle: conto.author,
        isFavorited: conto.isFavorited,
        callbackArg: [conto.reference.documentID, !conto.isFavorited]);
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