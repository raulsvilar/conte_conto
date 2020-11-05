import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ItemWithImageTitleSub extends StatelessWidget {
  final String itemID;
  final String title;
  final String subTitle;
  final Function(List) onTapCallback;
  final Function(List) favoriteCallback;
  final List favoriteCallbackArgs;
  final List onTapCallbackArgs;
  final bool withFavorites;
  final bool isFavorited;
  final bool isContoFinished;
  final bool isContoInCorrection;
  final bool withStatusTrailing;

  ItemWithImageTitleSub(
      {@required this.itemID,
      @required this.title,
      this.onTapCallbackArgs,
      this.withFavorites = false,
      @required this.onTapCallback,
      this.withStatusTrailing = false,
      this.favoriteCallbackArgs,
      this.isContoFinished = false,
      this.isContoInCorrection = false,
      this.favoriteCallback,
      this.isFavorited,
      this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        //height: 72,
        child: ListTile(
          onTap: () => onTapCallback(onTapCallbackArgs ?? [context, itemID]),
          leading: FaIcon(FontAwesomeIcons.book),
          trailing: setTrailing(context),
          title: Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
          subtitle: (subTitle != null)
              ? Text(subTitle, style: TextStyle(fontSize: 14))
              : null,
        ));
  }

  Widget setTrailing(BuildContext context) {
    if (withFavorites) {
      return trailingFavorite();
    } else if (withStatusTrailing) {
      if (isContoFinished)
        return buildCircle(context, Colors.green);
      else if (isContoInCorrection)
        return buildCircle(context, Colors.amber);
      else
        return buildCircle(context, Colors.red);
    }
    /*
    if (isContoFinished)
      return Text("Finalizado");
    else if (isContoInCorrection)
      return Text("Em correção");
    else
      return Text("Em edição");*/
  }

  Widget buildCircle(context, color) {
    return ColorFiltered(
        colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.modulate),
        child: FaIcon(FontAwesomeIcons.solidCircle, color: color, size: 12.0));
  }

  Widget trailingFavorite() {
    return IconButton(
        icon: isFavorited
            ? Icon(
                Icons.favorite,
                color: Colors.red,
              )
            : Icon(Icons.favorite_border),
        onPressed: () => favoriteCallback(favoriteCallbackArgs));
  }
}
