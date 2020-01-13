import 'package:conte_conto/src/blocs/favorities_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class FavoritiesPage extends ContosListBase<FavoritiesBloc> {

  FavoritiesPage(String turmaId) : super(turmaId);

  @override
  List<Widget> appBarActions(BuildContext context) {
    return null;
  }

  @override
  List<bottomItems> bottomNavigationItems() {
    return [bottomItems.library, bottomItems.favorites, bottomItems.messages];
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(conto.reference.documentID,
      conto.title,
      conto.isFavorited,
      onTapConto,
      subTitle: conto.author,
      setFavoriteCallback: bloc.setFavorite,
      callbackArg: [conto.reference.documentID, !conto.isFavorited]);
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    return null;
  }

}