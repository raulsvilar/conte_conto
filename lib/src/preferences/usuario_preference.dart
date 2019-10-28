import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

abstract class UsuarioPreference {
  static final String _usuario = "usuario";

  static Future<bool> setUsuario(String usuario) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_usuario, json.encode(usuario));
  }

  static Future<String> getUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usuario);
  }

  static Future<bool> isAuthenticated() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usuario) != null;
  }

  static Future<Null> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_usuario);
  }
}
