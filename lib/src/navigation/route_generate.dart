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
      case DESCRIPTION_HOME_PAGE:
        return MaterialPageRoute(builder: (_) => HomePage());
      case DESCRIPTION_CORRECTIONS_LIST_PAGE:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => CorrectionsListPage(args[0]));
        }
        return _errorRoute("Tipo inválido no argumento de CorrectionsListPage");
      case DESCRIPTION_EDITOR_CORRECTIONS:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => CorrectionEditorPage(args[0], args[1]));
        }
        return _errorRoute("Tipo inválido no argumento de CorrectionsListPage");
      case DESCRIPTION_CORRECTION_PAGE:
        return MaterialPageRoute(builder: (_) => CorrectionsPage());
      case DESCRIPTION_REGISTER_PAGE:
        return MaterialPageRoute(builder: (_) => RegisterPage());
      case DESCRIPTION_STUDENTS_CLASS_CONTOS_PAGE:
        return MaterialPageRoute(builder: (_) => StudentsClassContosPage());
      case DESCRIPTION_HELP_LIST_PAGE:
        return MaterialPageRoute(builder: (_) => HelpMaterialListPage());
      case DESCRIPTION_FAVORITES_PAGE:
        return MaterialPageRoute(builder: (_) => FavoritesPage());
      case DESCRIPTION_HELP_EDITOR_PAGE:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => HelpEditorPage(args[0], args[1], args[2], args[3]));
        }
        return _errorRoute("Tipo inválido no argumento de HelpEditorPage");
      case DESCRIPTION_STUDENT_CONTOS_LIST_PAGE:
        return MaterialPageRoute(builder: (_) => StudentContosList());
      case DESCRIPTION_EDITOR_PAGE:
        if (args is List) {
          if (args.length > 2)
            return MaterialPageRoute(
                builder: (_) => EditorPage(args[0], args[1],
                    isMaterial: args[2] ?? false,
                    materialName: args[3] ?? null));
          else
            return MaterialPageRoute(
                builder: (_) => EditorPage(args[0], args[1]));
        }
        return _errorRoute("Tipo inválido no argumento de EditorPage");
      case DESCRIPTION_TEACHER_CONTOS_LIST_PAGE:
        if (args is List) {
          return MaterialPageRoute(
              builder: (_) => TeacherContosList(args[0], args[1]));
        }
        return _errorRoute("Tipo inválido no argumento de ContosList");
      default:
        return _errorRoute("Rota não encontrada");
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
