import 'package:flutter/material.dart';

import 'route_generate.dart';

class BottomNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  const BottomNavigator({this.navigatorKey, this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
