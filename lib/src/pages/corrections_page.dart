import 'package:conte_conto/src/blocs/corrections_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

class CorrectionsPage extends ContosListBase<CorrectionsBloc>{

  CorrectionsPage():super(title: "Correções");

  @override
  List<Widget> appBarActions(BuildContext context) {
    return null;
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
        itemID: conto.reference.id,
        title: conto.title,
        onTapCallback: onTapConto);
  }
  @override
  onPressedFloatingActionButton(BuildContext context) {
    return null;
  }

  @override
  onTapConto(List args) {
    Navigator.of(args[0]).pushNamed(DESCRIPTION_CORRECTIONS_LIST_PAGE,
        arguments: [args[1]]);
  }

}