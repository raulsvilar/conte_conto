import 'package:flutter/material.dart';

class ItemWithImageTitleSub extends StatelessWidget {
  final String _itemID;
  final String _title;
  final String subTitle;
  final _onTapCallback;
  final setFavoriteCallback;
  final callbackArg;
  final bool _withFavorites;
  final bool isFavorited;

  ItemWithImageTitleSub(this._itemID, this._title,
      this._withFavorites, this._onTapCallback, {this.callbackArg,
        this.setFavoriteCallback, this.isFavorited, this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 72,
      child: ListTile(
        onTap: () => _onTapCallback(_itemID, context),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
        ),
        trailing: !_withFavorites ? null : IconButton(
            icon: isFavorited ? Icon(Icons.favorite, color: Colors.red,) : Icon(Icons.favorite_border),
            onPressed: () => setFavoriteCallback(callbackArg[0], callbackArg[1])),
        title: Text(
          _title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: subTitle != null ? Text(subTitle, style: TextStyle(fontSize: 14)) : null,
      ),
    );
  }
}
