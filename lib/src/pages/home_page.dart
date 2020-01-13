import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/navigation/navigator.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

import 'base/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  final User user;
  final navigatorKey = GlobalKey<NavigatorState>();

  HomePage(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BottomNavigator(
        navigatorKey: navigatorKey,
        initialRoute: getInitialRouteByUserType(user.type),
      ),
      bottomNavigationBar: BottomNavigation(
        items: getNavitationItemsByUserType(user.type),
        onTapCallback: () => null,
      ),
    );
  }

  List<bottomItems> getNavitationItemsByUserType(userTypes userType) {
    switch(userType) {
      case userTypes.student:
        return [
          bottomItems.library,
          bottomItems.favorites,
          bottomItems.messages
        ];
      case userTypes.teacher:
        return [
          bottomItems.library,
          bottomItems.messages,
          bottomItems.help,
        ];
    }
  }

  String getInitialRouteByUserType(userTypes userType) {
    switch(userType) {
      case userTypes.student:
        return DESCRIPTION_STUDENT_CONTOS_LIST_PAGE;
        break;
      case userTypes.teacher:
        return DESCRIPTION_CLASSES_PAGE;
        break;
    }
  }
}