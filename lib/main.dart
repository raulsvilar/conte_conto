import 'package:conte_conto/src/blocs/bottom_navigation_bloc.dart';
import 'package:conte_conto/src/blocs/contos_list_bloc.dart';
import 'package:conte_conto/src/blocs/login_bloc.dart';
import 'package:conte_conto/src/blocs/register_bloc.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/app_theme.dart';
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
        theme: AppTheme.theme,
        initialRoute: DESCRIPTION_LOGIN_PAGE,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
      blocs: [
        Bloc((i) => LoginBloc()),
        Bloc((i) => RegisterBloc()),
        Bloc((i) => TurmasBloc()),
        Bloc((i) => ContosListBloc()),
        Bloc((i) => BottomNavigationBloc())
      ],
    );
  }
}
