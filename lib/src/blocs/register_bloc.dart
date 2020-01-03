import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:rxdart/rxdart.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/validator.dart';


class RegisterBloc extends BlocBase with Validator {

  final _authentication = Authentication();

  
  final _hidePasswordController = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get hidePassword => _hidePasswordController.stream;
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
      Rx.combineLatest3(email, password, name, (e, p, n) => true);
  

  Future<String> register(String email, String name, String password, int type) async {
    _controllerLoading.add(true);
    try {
      User userModel = User.fromMap({
        'name': name,
        'email': email,
        'type': type,
        'password': password
      });
      userModel = await _authentication.signUp(userModel);
      print(userModel.reference.toString());
    } catch (e) {
      _controllerLoading.add(false);
      return e.toString();
    }
    _controllerLoading.add(false);
    return "true";
  }

  submit(Function() navigate) async {
    final validEmail = _emailController.value.trim();
    final validName = _nameController.value.trim();
    final validPassword = _passwordController.value.trim();
    final userType = _userTypeController.value.index;
    String result =  await register(validEmail, validName, validPassword, userType);
    if (result.contains("true")) {
      navigate();
    }
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
