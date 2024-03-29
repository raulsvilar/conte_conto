import 'package:conte_conto/src/blocs/bottom_navigation_bloc.dart';
import 'package:conte_conto/src/blocs/correction_editor_bloc.dart';
import 'package:conte_conto/src/blocs/corrections_bloc.dart';
import 'package:conte_conto/src/blocs/corrections_list_bloc.dart';
import 'package:conte_conto/src/blocs/editor_bloc.dart';
import 'package:conte_conto/src/blocs/favorites_bloc.dart';
import 'package:conte_conto/src/blocs/help_editor_bloc.dart';
import 'package:conte_conto/src/blocs/help_material_list_bloc.dart';
import 'package:conte_conto/src/blocs/home_bloc.dart';
import 'package:conte_conto/src/blocs/login_bloc.dart';
import 'package:conte_conto/src/blocs/register_bloc.dart';
import 'package:conte_conto/src/blocs/student_contos_list_bloc.dart';
import 'package:conte_conto/src/blocs/students_class_contos_bloc.dart';
import 'package:conte_conto/src/blocs/teacher_contos_list_bloc.dart';
import 'package:conte_conto/src/blocs/turmas_bloc.dart';
import 'package:conte_conto/src/navigation/route_generate.dart';
import 'package:conte_conto/src/navigation/routes.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/app_theme.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  preloadSVG() async {
    await precachePicture(
      ExactAssetPicture(SvgPicture.svgStringDecoder, DESCRIPTION_APP_LOGO),
      null,
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {

        preloadSVG();
        // Check for errors
        if (snapshot.hasError) {
          print(snapshot.error);
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          GetIt getIt = GetIt.I;
          if (!getIt.isRegistered<FirestoreProvider>()) {
            getIt.registerLazySingleton<FirestoreProvider>(
                () => FirestoreProvider());
          }
          if (!getIt.isRegistered<Authentication>()) {
            getIt.registerLazySingleton<Authentication>(() => Authentication());
          }
          return BlocProvider(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: DESCRIPTION_APP_TITLE,
              theme: AppTheme.theme,
              home: SafeArea(child: LoginPage()),
              onGenerateRoute: RouteGenerator.generateRoute,
            ),
            blocs: [
              Bloc((i) => LoginBloc()),
              Bloc((i) => RegisterBloc()),
              Bloc((i) => TurmasBloc()),
              Bloc((i) => StudentsClassContosBloc()),
              Bloc((i) => TeacherContosListBloc()),
              Bloc((i) => BottomNavigationBloc()),
              Bloc((i) => StudentContosListBloc()),
              Bloc((i) => FavoritesBloc()),
              Bloc((i) => EditorBloc()),
              Bloc((i) => HomeBloc()),
              Bloc((i) => CorrectionsBloc()),
              Bloc((i) => CorrectionsListBloc()),
              Bloc((i) => HelpEditorBloc()),
              Bloc((i) => HelpMaterialListBloc()),
              Bloc((i) => EditorCorrectionsBloc())
            ],
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
