import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/validator.dart';

class LoginBloc extends BlocBase with Validator {
  final _authentication = GetIt.I.get<Authentication>();

  final _hidePasswordController = BehaviorSubject<bool>.seeded(true);
  Function(bool) get changeHidePassword => _hidePasswordController.sink.add;
  Stream<bool> get hidePassword => _hidePasswordController.stream;

  final _controllerLoading = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get outLoading => _controllerLoading.stream;

  final _emailController = BehaviorSubject<String>();
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Function(String) get changeEmail => _emailController.sink.add;

  final _passwordController = BehaviorSubject<String>();
  Function(String) get changePassword => _passwordController.sink.add;
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get submitValid =>
      Rx.combineLatest2(email, password, (e, p) => true);

  final _controllerLogged = BehaviorSubject<bool>();
  Stream<bool> get isLogged => _controllerLogged.stream;

  Future<User> login(String email, String password) async {
    _controllerLoading.add(true);
    try {
      return await _authentication.signIn(email, password);
    } catch (e) {
      _controllerLoading.add(false);
      print(e.toString());
      return null;
    } finally {
      _controllerLoading.add(false);
    }
  }

  getLoggedUser(Function(User) navigationCallback) async {
    await _authentication.getCurrentUser().then((user) {
      _controllerLogged.add(true);
      routeByUser(user, navigationCallback);
    }).catchError((e) {
      _controllerLogged.add(false);
    });
  }

  submit(Function failCallback, Function(User) navigationCallback) async {
    final validEmail = _emailController.value.trim();
    final validPassword = _passwordController.value.trim();
    User user = await login(validEmail, validPassword);
    user != null ? routeByUser(user, navigationCallback) : failCallback();
  }

  routeByUser(User user, Function(User) navigationCallback) {
    GetIt.I.registerSingleton<User>(user);
    navigationCallback(user);
  }

  @override
  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _hidePasswordController?.close();
    _controllerLogged.close();
    super.dispose();
  }

  void resetPassword(String email) {
    _authentication.resetPassword(email);
  }
}
