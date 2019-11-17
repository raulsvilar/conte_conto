import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class BottomNavigationBloc extends BlocBase {
  final _controllerTab = BehaviorSubject<int>.seeded(0);
  Stream<int> get tab => _controllerTab.stream;
  Function(int) get setTab => _controllerTab.sink.add;

  @override
  dispose() {
    _controllerTab.close();
    super.dispose();
  }
}