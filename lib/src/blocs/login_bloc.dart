import 'package:conte_conto/src/models/user.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:conte_conto/src/utils/constants.dart';
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

  final _controllerLogged = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLogged => _controllerLogged.stream;


  Future<User> login(String email, String password) async{
    _controllerLoading.add(true);
    try {
      return await _authentication.signIn(email, password);
    } catch (e) {
      _controllerLoading.add(false);
      print(e.toString());
      return null;
    }
    finally {
      _controllerLoading.add(false);
    }
  }

  getLoggedUser(Function(String, List<String>) navigationCallback) async{
    User user = await _authentication.getCurrentUser();
    if (user != null)
      routeByUser(user, navigationCallback);
  }

  submit(Function failCallback, Function(String, List<String>) navigationCallback) async{
    final validEmail = _emailController.value.trim();
    final validPassword = _passwordController.value.trim();
    User user = await login(validEmail, validPassword);
    user != null ? routeByUser(user, navigationCallback) : failCallback();
  }

  routeByUser(User user, Function(String, List<String>) navigationCallback) {
      switch (user.type) {
        case userTypes.student:
          navigationCallback(DESCRIPTION_STUDENT_CONTOS_LIST_PAGE, [user.reference.documentID, user.turmaID]);
          break;
        case userTypes.teacher:
          navigationCallback(DESCRIPTION_CLASS_NAME, [user.reference.documentID]);
          break;
      }
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
