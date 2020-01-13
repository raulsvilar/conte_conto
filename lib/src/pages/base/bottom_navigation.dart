import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/bottom_navigation_bloc.dart';
import 'package:flutter/material.dart';

enum bottomItems {
  favorites,
  library,
  messages,
  help
}

class BottomNavigation extends StatelessWidget {

  final _bloc = BlocProvider.getBloc<BottomNavigationBloc>();

  final List<bottomItems> items;
  final onTapCallback;

  BottomNavigation({@required this.items,@required this.onTapCallback});

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
    for (bottomItems item in items) {
      switch (item) {
        case bottomItems.favorites:
          listItems.add(BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favoritos')
          ));
          break;
        case bottomItems.messages:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Mensagens')
          ));
          break;
        case bottomItems.library:
          listItems.add(BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Turmas')
          ));
          break;
        case bottomItems.help:
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