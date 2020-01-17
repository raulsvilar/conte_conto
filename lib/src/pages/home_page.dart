import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/home_bloc.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/navigation/navigator.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  final User user = GetIt.I.get<User>();
  final _bloc = BlocProvider.getBloc<HomeBloc>();

  final Map<bottomItems, GlobalKey<NavigatorState>> navigatorKeys = {
    bottomItems.favorites: GlobalKey<NavigatorState>(),
    bottomItems.help: GlobalKey<NavigatorState>(),
    bottomItems.classes: GlobalKey<NavigatorState>(),
    bottomItems.messages: GlobalKey<NavigatorState>(),
    bottomItems.contos: GlobalKey<NavigatorState>(),
    bottomItems.finished_contos: GlobalKey<NavigatorState>(),
  };

  final Map<bottomItems, String> initialRoutes = {
    bottomItems.favorites: DESCRIPTION_FAVORITES_PAGE,
    bottomItems.contos: DESCRIPTION_STUDENT_CONTOS_LIST_PAGE,
    bottomItems.finished_contos: DESCRIPTION_STUDENTS_CLASS_CONTOS_PAGE,
    bottomItems.classes: DESCRIPTION_CLASSES_PAGE,
  };

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.tab,
      builder: (context, snapshot) {
        return WillPopScope(
          onWillPop: () async => !await navigatorKeys[
                  _bloc.getNavitationItemsByUserType(
                      user.type)[snapshot.hasData ? snapshot.data : 0]]
              .currentState
              .maybePop(),
          child: Scaffold(
            body: Stack(
              children: _bloc.getNavigatorsOffstageByUser(
                  user.type, _buildOffstageNavigator),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: _createItems(
                _bloc.getNavitationItemsByUserType(user.type),
              ),
              type: BottomNavigationBarType.fixed,
              onTap: (index) => _bloc.setTab(index),
              currentIndex: snapshot.hasData ? snapshot.data : 0,
            ),
          ),
        );
      },
    );
  }

  List<BottomNavigationBarItem> _createItems(List<bottomItems> items) {
    List<BottomNavigationBarItem> listItems = [];
    for (bottomItems item in items) {
      switch (item) {
        case bottomItems.favorites:
          listItems.add(
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favoritos'),
            ),
          );
          break;
        case bottomItems.messages:
          listItems.add(
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Mensagens'),
            ),
          );
          break;
        case bottomItems.classes:
          listItems.add(
            BottomNavigationBarItem(
              icon: Icon(Icons.book),
              title: Text('Turmas'),
            ),
          );
          break;
        case bottomItems.help:
          listItems.add(
            BottomNavigationBarItem(
              icon: Icon(Icons.help),
              title: Text('Ajuda'),
            ),
          );
          break;
        case bottomItems.contos:
          listItems.add(
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidEdit),
              title: Text('Contos'),
            ),
          );
          break;
        case bottomItems.finished_contos:
          listItems.add(
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.bookReader),
              title: Text('Turma'),
            ),
          );
          break;
      }
    }
    return listItems;
  }

  Widget _buildOffstageNavigator(bottomItems bottomItem) {
    return StreamBuilder(
      stream: _bloc.tab,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Offstage(
            offstage:
                _bloc.getNavitationItemsByUserType(user.type)[snapshot.data] !=
                    bottomItem,
            child: BottomNavigator(
              navigatorKey: navigatorKeys[bottomItem],
              initialRoute: initialRoutes[bottomItem],
            ),
          );
        }
        return Container();
      },
    );
  }
}
