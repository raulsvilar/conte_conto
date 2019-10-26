import 'package:flutter/material.dart';

enum Items {
  favorites,
  library,
  messages
}

class BottomNavigation extends StatelessWidget {

  var _items, _onTapCallback, _currentIndex = 0;

  BottomNavigation(this._items, this._onTapCallback);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: _createItems(),
      onTap: _onTapCallback,
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
    );
  }

  _createItems() {
    List<BottomNavigationBarItem> listItems = [];
    for (Items item in _items) {
      switch (item) {
        case Items.favorites:
          listItems.add(BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favoritos')
          ));
          break;
        case Items.messages:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Mensagens')
          ));
          break;
        case Items.library:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Turmas')
          ));
          break;
      }
    }
    return listItems;
  }
  
}