import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bloc_pattern/bloc_pattern.dart';

import 'package:conte_conto/src/utils/constants.dart';
import 'package:conte_conto/src/blocs/register_bloc.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.getBloc<RegisterBloc>();
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

  Card buildCard(RegisterBloc bloc, BuildContext context) {
    return Card(
      child: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            userTypeFields(bloc),
            nameField(bloc),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: emailField(bloc),
            ),
            Container(
              margin: EdgeInsets.only(top: 8, bottom: 16),
              child: passwordField(bloc),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                loginButton(context),
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

  Widget nameField(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.name,
      builder: (context, snapshot) {
        return TextField(
          //    cursorColor: primaryColor2,
          onChanged: bloc.changeName,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            labelText: DESCRIPTION_NAME,
            errorText: snapshot.error,
          ),
        );
      },
    );
  }

  Widget emailField(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: (context, snapshot) {
        return TextField(
          //     cursorColor: primaryColor2,
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

  Widget passwordField(RegisterBloc bloc) {
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

  Widget loginButton(BuildContext context) {
    return FlatButton(
      child: Text(
        DESCRIPTION_ENTER.toUpperCase(),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget userTypeFields(RegisterBloc bloc) {
    return StreamBuilder(
      stream: bloc.userType,
      builder: (context, snapshot) {
        return Container(
          child: MaterialSegmentedControl(
            horizontalPadding: EdgeInsets.only(bottom: 8),
            children: {
              userTypes.student: Text(USER_TYPE_STUDENT.toUpperCase()),
              userTypes.teacher: Text("  $USER_TYPE_TEACHER  ".toUpperCase())
            },
            selectionIndex: snapshot.data,
            borderColor: Colors.grey,
            selectedColor: Theme.of(context).accentColor,
            unselectedColor: Colors.white,
            borderRadius: 32.0,
            onSegmentChosen: (index) {
              bloc.changeUserType(index);
            },
          ),
        );
      },
    );
  }

  Widget submitButton(RegisterBloc bloc, BuildContext context) {
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
                  DESCRIPTION_REGISTER.toUpperCase(),
                ),
                textColor: Colors.white,
                onPressed: snapshot.hasData && snapshot.data
                    ? () => bloc.submit(
                        context, navigationAfterRegister, errorRegisterDialog)
                    : null,
              );
            },
          );
        }
      },
    );
  }

  navigationAfterRegister(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(DESCRIPTION_HOME_PAGE);
  }

  errorRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(DESCRIPTION_DIALOG_ERROR),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[Text(DESCRIPTION_INVALID_USER_PASSWORD)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(DIALOG_BUTTON_CANCEL),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
