import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class CorrectionsPage extends ContosListBase{

  @override
  List<Widget> appBarActions(BuildContext context) {
    return null;
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return null;
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    return null;
  }

  @override
  onTapConto(List args) {
    return super.onTapConto(args);
  }

}