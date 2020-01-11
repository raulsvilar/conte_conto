import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:flutter/material.dart';

mixin BottomNavigate {

  void bottomNavigation(bottomItems bottomBarListItem, BuildContext context, Function(BuildContext, String, List) bottomNavigationCallback) {
    switch(bottomBarListItem) {

      case bottomItems.library:
      // TODO: Handle this case.
        break;
      case bottomItems.messages:
      // TODO: Handle this case.
        break;
      case bottomItems.help:
      // TODO: Handle this case.
        break;
      case bottomItems.favorites:
        // TODO: Handle this case.
        break;
    }
  }
}