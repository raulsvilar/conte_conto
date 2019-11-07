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
          bottomAppBarColor: Colors.amber[700],
          brightness: Brightness.light,
          backgroundColor: Colors.grey[100],
          primaryColor: Colors.blue[100],
          accentColor: Colors.amber[700],
          primaryColorDark: Color(0xff8aacc8),
          primaryColorLight: Color(0xFFeeffff),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.amber[700],
            textTheme: ButtonTextTheme.accent
          ),
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
