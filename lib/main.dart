import 'package:conte_conto/src/blocs/bottom_navigation_bloc.dart';
import 'package:conte_conto/src/blocs/editor_bloc.dart';
import 'package:conte_conto/src/blocs/login_bloc.dart';
import 'package:conte_conto/src/blocs/register_bloc.dart';
import 'package:conte_conto/src/blocs/student_contos_list_bloc.dart';
import 'package:conte_conto/src/blocs/teacher_contos_list_bloc.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/app_theme.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:conte_conto/src/utils/route_generate.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt getIt = GetIt.I;
  getIt.registerLazySingleton<FirestoreProvider>(() => FirestoreProvider());
  getIt.registerLazySingleton<Authentication>(() => Authentication());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: DESCRIPTION_APP_TITLE,
        theme: AppTheme.theme,
        initialRoute: DESCRIPTION_LOGIN_PAGE,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      blocs: [
        Bloc((i) => LoginBloc()),
        Bloc((i) => RegisterBloc()),
        Bloc((i) => TurmasBloc()),
        Bloc((i) => TeacherContosListBloc()),
        Bloc((i) => BottomNavigationBloc()),
        Bloc((i) => StudentContosListBloc()),
        Bloc((i) => EditorBloc())
      ],
    );
  }
}
