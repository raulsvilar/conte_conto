import 'package:conte_conto/src/blocs/favorites_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends ContosListBase<FavoritesBloc> {
  FavoritesPage() : super();

  @override
  List<Widget> appBarActions(BuildContext context) {
    return null;
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
        itemID: conto.reference.documentID,
        title: conto.title,
        withFavorites: true,
        onTapCallback: onTapConto,
        subTitle: conto.author,
        isFavorited: conto.isFavorited,
        favoriteCallback: bloc.setFavorite,
        favoriteCallbackArgs: [conto.reference.documentID, !conto.isFavorited]);
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    return null;
  }
}
