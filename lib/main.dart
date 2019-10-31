import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/blocs/login_bloc.dart';
import 'package:conte_conto/src/blocs/register_bloc.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/app_themes.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:conte_conto/src/utils/route_generate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: DESCRIPTION_APP_TITLE,
        theme: ThemeData(
          brightness: Brightness.light,
          backgroundColor: Colors.grey[100],
          primaryColor: AppThemes.primaryColor[500],
          primarySwatch: MaterialColor(
            0xffb8d7f1,
            AppThemes.primaryColor,
          ),
          accentColor: AppThemes.primaryColor[500],
          secondaryHeaderColor: AppThemes.secundaryColor[500],
          appBarTheme: AppThemes.appBarTheme,
          tabBarTheme: AppThemes.tabBarTheme,
        ),
        initialRoute: DESCRIPTION_LOGIN_PAGE,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      blocs: [
        Bloc((i) => LoginBloc()),
        Bloc((i) => RegisterBloc()),
        Bloc((i) => TurmasBloc()),
        Bloc((i) => ContosListBloc()),
      ],
    );
  }
}
