import 'package:conte_conto/src/pages/contos_list.dart';
import 'package:conte_conto/src/pages/correction_page.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import 'constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case DESCRIPTION_CLASSES_PAGE:
        if (args is List) {
          return MaterialPageRoute(builder: (_) => TurmasPage(args[0]));
        } return _errorRoute("Tipo inválido no argumento de ContosList");
      case DESCRIPTION_LOGIN_PAGE:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case DESCRIPTION_REGISTER_PAGE:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case DESCRIPTION_CORRECTION_PAGE:
        return MaterialPageRoute(builder: (_) => CorrectionPage());
      case DESCRIPTION_CONTOS_LIST_PAGE:
        if (args is List) {
          return MaterialPageRoute(builder: (_) => ContosList(args[0]));
        } return _errorRoute("Tipo inválido no argumento de ContosList");
      default:
        if (args is List) {
          return MaterialPageRoute(builder: (_) => TurmasPage(args[0]));
        } return _errorRoute("Tipo inválido no argumento de ContosList");
    }
  }

  static Route<dynamic> _errorRoute(String error) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text(DESCRIPTION_DIALOG_ERROR),
        ),
        body: Center(
          child: Text(error),
        ),
      );
    });
  }
}
