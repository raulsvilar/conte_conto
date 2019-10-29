import 'package:flutter/material.dart';

class ItemWithImageTitleSub extends StatelessWidget {
  final String _title;
  final String _subTitle;
  final _onTapCallback;

  ItemWithImageTitleSub(this._title, this._subTitle, this._onTapCallback);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 72,
      child: ListTile(
        onTap: () => _onTapCallback(),
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
