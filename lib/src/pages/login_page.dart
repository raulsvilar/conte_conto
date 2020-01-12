import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/constants.dart';
import 'package:conte_conto/src/blocs/login_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {

  final _bloc = BlocProvider.getBloc<LoginBloc>();

  @override
  void initState() {
    _bloc.getLoggedUser(navigationAfterLogin);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: _bloc.isLogged,
        builder: (_, snapshot) {
          if (snapshot.hasData && !snapshot.data) {
              return _buildBody();

          }
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        },
      ),
    );
  }

  Card buildCard() {
    return Card(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            emailField(),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: passwordField(_bloc),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                registerButton(context),
                submitButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 30),
      child: SvgPicture.asset(
        DESCRIPTION_APP_LOGO,
        fit: BoxFit.fitHeight,
        height: 150,
      ),
    );
  }

  Widget emailField() {
    return StreamBuilder(
      stream: _bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: _bloc.changeEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: DESCRIPTION_EMAIL,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget passwordField(LoginBloc bloc) {
    return StreamBuilder<String>(
      stream: bloc.password,
      builder: (context, snapshot) {
        return StreamBuilder<bool>(
          stream: bloc.hidePassword,
          initialData: true,
          builder: (context, hideSnapshot) {
            return TextField(
              obscureText: hideSnapshot.data,
              onChanged: bloc.changePassword,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: () => bloc.changeHidePassword(!hideSnapshot.data),
                  icon: Icon(
                    hideSnapshot.data ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
                labelText: DESCRIPTION_PASSWORD,
                errorText: snapshot.error,
              ),
            );
          },
        );
      },
    );
  }

  Widget registerButton(BuildContext context) {
    return FlatButton(

      child: Text(
        DESCRIPTION_REGISTER.toUpperCase(),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(DESCRIPTION_REGISTER_PAGE);
      },
    );
  }

  Widget submitButton() {
    return StreamBuilder<Object>(
      stream: _bloc.outLoading,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );
        } else {
          return StreamBuilder(
            stream: _bloc.submitValid,
            builder: (_, snapshot) {
              return RaisedButton(
                child: Text(
                  DESCRIPTION_ENTER.toUpperCase(),
                ),
                textColor: Colors.white,
                onPressed: () => _bloc.submit(lostPasswordDialog, navigationAfterLogin)
              );
            },
          );
        }
      },
    );
  }

  lostPasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DESCRIPTION_DIALOG_ERROR),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(DESCRIPTION_INVALID_USER_PASSWORD)
              ],
            ),
          ),
          actions: <Widget>[
            StreamBuilder<String>(
              stream: _bloc.email,
              builder: (_, snapshot) {
                return FlatButton(
                  child: Text(DESCRIPTION_RESET_PASSWORD),
                  onPressed: () {
                    _bloc.resetPassword(snapshot.data);
                    Fluttertoast.showToast(
                        msg: "$DESCRIPTION_SEND_RESET_EMAIL ${snapshot.data}",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM
                    );
                    Navigator.pop(context);
                    },
                );
              },
            ),
            FlatButton(
              child: Text(DIALOG_BUTTON_CANCEL),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }

  navigationAfterLogin(namedRoute, args) {
    Navigator.of(context).pushReplacementNamed(namedRoute, arguments: args);
  }

  _buildBody() {
    final _screenSize = MediaQuery.of(context).size;
    return Center(
      child: Container(
        width: _screenSize.width * .8,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              buildLogo(),
              buildCard(),
            ],
          ),
        ),
      ),
    );
  }

}
