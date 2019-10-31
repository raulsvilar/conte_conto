import 'package:flutter/material.dart';

class ItemWithImageTitleSub extends StatelessWidget {
  final String _title;
  final String _subTitle;
  final _onTapCallback;
  final callbackArg;

  ItemWithImageTitleSub(this._title, this._subTitle, this._onTapCallback, {this.callbackArg});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 72,
      child: ListTile(
        onTap: () => _onTapCallback(callbackArg),
        leading: CircleAvatar(
          backgroundColor: Colors.grey,
        ),
        title: Text(
          _title,
          style: TextStyle(fontSize: 16),
        ),
        subtitle: Text(_subTitle, style: TextStyle(fontSize: 14)),
      ),
    );
  }
}
