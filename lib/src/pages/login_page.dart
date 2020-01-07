import 'package:conte_conto/src/resources/fireauth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/constants.dart';
import 'package:conte_conto/src/blocs/login_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {

  LoginPage() {
    print(Authentication().getCurrentUser().then((value) => print(value.uid)));
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<LoginBloc>();
    final _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Center(
        child: Container(
          width: _screenSize.width * .8,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                buildLogo(),
                buildCard(bloc, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Card buildCard(LoginBloc bloc, BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            emailField(bloc),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: passwordField(bloc),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                registerButton(context),
                submitButton(bloc, context),
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

  Widget emailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeEmail,
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

  Widget submitButton(LoginBloc bloc, BuildContext context) {
    return StreamBuilder<Object>(
      stream: bloc.outLoading,
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
            stream: bloc.submitValid,
            builder: (_, snapshot) {
              return RaisedButton(
                child: Text(
                  DESCRIPTION_ENTER.toUpperCase(),
                ),
                textColor: Colors.white,
                onPressed: () => bloc.submit(context)
              );
            },
          );
        }
      },
    );
  }
}
