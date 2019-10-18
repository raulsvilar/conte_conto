import 'package:flutter/material.dart';

class ItemWithImageTitleSub extends StatelessWidget {

  final String _title;
  final String _subTitle;

  ItemWithImageTitleSub(this._title, this._subTitle);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 72,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.grey,
          ),
          Container(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  _title,
                  style: TextStyle(fontSize: 16),
                ),
                Opacity(
                    opacity: 0.54,
                    child: Text(
                        _subTitle,
                        style: TextStyle(fontSize: 14)
                    )),
              ])
          )],
          ),
    );
  }

}