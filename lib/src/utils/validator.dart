import 'dart:async';

import 'constants.dart';

mixin Validator {
  static final Pattern emailPattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  final validateField =
      StreamTransformer<String, String>.fromHandlers(handleData: (field, sink) {
    if (field.isEmpty) {
      sink.addError(DESCRIPTION_MISSING_FIELD);
    } else {
      sink.add(field);
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 5) {
      sink.add(password);
    } else if (password.isEmpty)
      sink.addError(DESCRIPTION_MISSING_FIELD);
    else {
      sink.addError(DESCRIPTION_INVALID_PASSWORD);
    }
  });

  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    RegExp regExp = RegExp(emailPattern);
    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else if (email.isEmpty) {
      sink.addError(DESCRIPTION_MISSING_FIELD);
    } else {
      sink.addError(DESCRIPTION_INVALID_EMAIL);
    }
  });

  final validateJustEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    RegExp regExp = RegExp(emailPattern);
    if (regExp.hasMatch(email) || email.isEmpty) {
      sink.add(email);
    } else {
      sink.addError(DESCRIPTION_INVALID_EMAIL);
    }
  });
}
