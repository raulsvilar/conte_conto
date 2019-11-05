import 'package:conte_conto/src/preferences/usuario_preference.dart';
import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/validator.dart';

enum userTypes {
  student,
  teacher
}


class RegisterBloc extends BlocBase with Validator {

  final authentication = Authentication();

  
  final _hidePasswordController = BehaviorSubject<bool>.seeded(true);
  Observable<bool> get hidePassword => _hidePasswordController.stream;
  Function(bool) get changeHidePassword => _hidePasswordController.sink.add;
  
  
  final _controllerLoading = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get outLoading => _controllerLoading.stream;
  
  
  final _emailController = BehaviorSubject<String>();
  Stream<String> get email => _emailController.stream.transform(validateEmail);
  Function(String) get changeEmail => _emailController.sink.add;
  
  
  final _nameController = BehaviorSubject<String>();
  Stream<String> get name => _emailController.stream.transform(validateField);
  Function(String) get changeName => _nameController.sink.add;
  
  
  final _passwordController = BehaviorSubject<String>();
  Function(String) get changePassword => _passwordController.sink.add;
  Stream<String> get password =>
      _passwordController.stream.transform(validatePassword);
  

  final _userTypeController = BehaviorSubject<userTypes>.seeded(userTypes.student);
  Stream<userTypes> get userType => _userTypeController.stream;
  Function(userTypes) get changeUserType => _userTypeController.sink.add;
  
  
  Stream<bool> get submitValid =>
      Observable.combineLatest3(email, password, name, (e, p, n) => true);
  

  Future<String> register(String email, String name, String password) async {
    _controllerLoading.add(true);
    try {
      var user = await authentication.signUp(email, password);
      print(user.uid);
      await UsuarioPreference.setUsuario(user.toString());
    } catch (e) {
      _controllerLoading.add(false);
      return e.toString();
    }
    _controllerLoading.add(false);
    return "true";
  }

  Future<String> submit() async {
    final validEmail = _emailController.value.trim();
    final validName = _nameController.value.trim();
    final validPassword = _passwordController.value.trim();

    return await register(validEmail, validName, validPassword);
  }

  @override
  dispose() {
    _emailController?.close();
    _nameController?.close();
    _passwordController?.close();
    _hidePasswordController?.close();
    _userTypeController?.close();
    super.dispose();
  }
}
