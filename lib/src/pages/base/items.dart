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

  ItemWithImageTitleSub(
      {@required this.itemID,
      @required this.title,
      this.onTapCallbackArgs,
      @required this.withFavorites,
      @required this.onTapCallback,
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
        trailing: !withFavorites
            ? null//trailingStatus(context, isContoFinished, isContoInCorrection) //FaIcon(FontAwesomeIcons.solidCircle, color: Colors.red.shade700)
            : trailingFavorite(),
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
//        subtitle: subTitle ?? Text(subTitle, style: TextStyle(fontSize: 14))
//            : null,
      ),
    );
  }



  Widget trailingStatus(BuildContext context, bool isFinished, bool inCorrection) {
    /*if (isFinished)
      return ColorFiltered(
          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.modulate),
          child: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.green));
    else if (inCorrection)
      return ColorFiltered(
          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.modulate),
          child: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.yellow));
    else
      return ColorFiltered(
          colorFilter: ColorFilter.mode(Theme.of(context).primaryColor, BlendMode.modulate),
          child: FaIcon(FontAwesomeIcons.solidCircle, color: Colors.red));*/
    if (isFinished)
      return Text("Finalizado");
    else if (inCorrection)
        return Text("Em correção");
    else return Text("Em edição");
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
