import 'package:conte_conto/src/pages/editor_page.dart';
import 'package:conte_conto/src/pages/teacher_contos_list.dart';
import 'package:conte_conto/src/pages/correction_page.dart';
import 'package:flutter/material.dart';

import 'routes.dart';
import '../utils/constants.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case DESCRIPTION_CLASSES_PAGE:
          return MaterialPageRoute(builder: (_) => TurmasPage());
      case DESCRIPTION_LOGIN_PAGE:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case DESCRIPTION_REGISTER_PAGE:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case DESCRIPTION_CORRECTION_PAGE:
        return MaterialPageRoute(builder: (_) => CorrectionPage());
      case DESCRIPTION_FAVORITES_PAGE:
        return MaterialPageRoute(builder: (_) => FavoritesPage());
      case DESCRIPTION_STUDENT_CONTOS_LIST_PAGE:
        if (args is List) {
          return MaterialPageRoute(builder: (_) => StudentContosList());
        } return _errorRoute("Tipo inválido no argumento de StudentContosList");
      case DESCRIPTION_EDITOR_PAGE:
        if (args is List) {
          return MaterialPageRoute(builder: (_) => EditorPage(args[0], args[1]));
        } return _errorRoute("Tipo inválido no argumento de EditorPage");
      case DESCRIPTION_TEACHER_CONTOS_LIST_PAGE:
        if (args is List) {
          return MaterialPageRoute(builder: (_) => TeacherContosList(args[0]));
        } return _errorRoute("Tipo inválido no argumento de ContosList");
      default:
          return MaterialPageRoute(builder: (_) => TurmasPage());
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
