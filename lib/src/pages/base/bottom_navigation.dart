import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/bottom_navigation_bloc.dart';
import 'package:flutter/material.dart';

enum Items {
  favorites,
  library,
  messages
}

class BottomNavigation extends StatelessWidget {


  final List<Items> _items;
  final _onTapCallback;

  BottomNavigation(this._items, this._onTapCallback);

  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.getBloc<BottomNavigationBloc>();
    return StreamBuilder(
      stream: _bloc.tab,
      builder: (context, snapshot) {
        return BottomNavigationBar(
          items: _createItems(),
          onTap: (i) => _bloc.setTab(i),
          type: BottomNavigationBarType.fixed,
          currentIndex: snapshot.data,
        );
      }
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