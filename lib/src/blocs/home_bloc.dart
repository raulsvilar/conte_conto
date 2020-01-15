import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

enum bottomItems { favorites, classes, contos, messages, help }

class HomeBloc extends BlocBase {
  final _controllerTab = BehaviorSubject<int>.seeded(0);

  Stream<int> get tab => _controllerTab.stream;

  Function(int) get setTab => _controllerTab.sink.add;

  List<bottomItems> items;

  initialRoute(userTypes type) {
    switch (type) {
      case userTypes.student:
        return DESCRIPTION_STUDENT_CONTOS_LIST_PAGE;
      case userTypes.teacher:
        return DESCRIPTION_CLASSES_PAGE;
    }
  }

  List<bottomItems> getNavitationItemsByUserType(userTypes userType) {
    switch (userType) {
      case userTypes.student:
        return [bottomItems.contos, bottomItems.messages, bottomItems.help];
      case userTypes.teacher:
        return [
          bottomItems.classes,
          bottomItems.favorites,
          bottomItems.messages
        ];
    }
  }

  List<Widget> getNavigatorsOffstageByUser(
      userTypes userType, Function(bottomItems) offstage) {
    switch (userType) {
      case userTypes.student:
        return [
          offstage(bottomItems.contos),
          offstage(bottomItems.messages),
          offstage(bottomItems.help)
        ];
      case userTypes.teacher:
        return [
          offstage(bottomItems.classes),
          offstage(bottomItems.favorites),
          offstage(bottomItems.messages)
        ];
    }
  }

  @override
  void dispose() {
    _controllerTab.close();
    super.dispose();
  }
}
