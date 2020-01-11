import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/bottom_navigation_bloc.dart';
import 'package:flutter/material.dart';

enum BottomItems {
  favorites,
  library,
  messages,
  help
}

class BottomNavigation extends StatelessWidget {

  final _bloc = BlocProvider.getBloc<BottomNavigationBloc>();

  final List<BottomItems> _items;
  final _onTapCallback;

  BottomNavigation(this._items, this._onTapCallback);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.tab,
      builder: (context, snapshot) {
        return BottomNavigationBar(
          items: _createItems(),
          onTap: (i) => _bloc.setTab(i),
          type: BottomNavigationBarType.fixed,
          currentIndex: snapshot.hasData ? snapshot.data : 0,
        );
      }
    );
  }

  _createItems() {
    List<BottomNavigationBarItem> listItems = [];
    for (BottomItems item in _items) {
      switch (item) {
        case BottomItems.favorites:
          listItems.add(BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favoritos')
          ));
          break;
        case BottomItems.messages:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Mensagens')
          ));
          break;
        case BottomItems.library:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Turmas')
          ));
          break;
        case BottomItems.help:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.help),
              title: Text('Ajuda')
          ));
          break;
      }
    }
    return listItems;
  }
  
}