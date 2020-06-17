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

  ItemWithImageTitleSub(
      {@required this.itemID,
      @required this.title,
      this.onTapCallbackArgs,
      @required this.withFavorites,
      @required this.onTapCallback,
      this.favoriteCallbackArgs,
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
            ? null //FaIcon(FontAwesomeIcons.solidCircle, color: Colors.red.shade700)
            : IconButton(
                icon: isFavorited
                    ? Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : Icon(Icons.favorite_border),
                onPressed: () => favoriteCallback(favoriteCallbackArgs)),
        title: Text(
          title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: subTitle != null
            ? Text(subTitle, style: TextStyle(fontSize: 14))
            : null,
      ),
    );
  }
}
