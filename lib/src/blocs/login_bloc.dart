import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/validator.dart';

class LoginBloc extends BlocBase with Validator {

  final _hidePasswordController = BehaviorSubject<bool>.seeded(true);
  final _controllerLoading = BehaviorSubject<bool>.seeded(false);
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Observable<bool> get hidePassword => _hidePasswordController.stream;

  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  
  Stream<bool> get outLoading => _controllerLoading.stream;
  
  Stream<bool> get submitValid =>
      Observable.combineLatest2(email, password, (e, p) => true);

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(bool) get changeHidePassword => _hidePasswordController.sink.add;

  Future<String> login(String email, String password) async {
    _controllerLoading.add(true);
    try {
      //await UsuarioPreference.setUsuario(user);
    } catch (e) {
      _controllerLoading.add(false);
      return e.toString();
    }
    _controllerLoading.add(false);
    return "true";
  }

  submit() {
    final validEmail = _emailController.value.trim();
    final validPassword = _passwordController.value.trim();
    
    //login(validEmail, validPassword);
    return "true";
  }

  @override
  dispose() {
    _emailController?.close();
    _passwordController?.close();
    _hidePasswordController?.close();
    super.dispose();
  }
}
