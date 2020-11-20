import 'package:conte_conto/src/models/user.dart' as UserModel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'dart:async';

import 'package:get_it/get_it.dart';

class Authentication {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = GetIt.I.get<FirestoreProvider>();

  Future<UserModel.User> signIn(String email, String password) async {
    return await _firebaseAuth
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then((result) => _firestore.getUser(result.user.uid));
  }

  Future<UserModel.User> signUp(UserModel.User user) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(
          email: user.email,
          password: user.password,
        )
        .catchError((error) => print(error.toString()))
        .then(((result) => _firestore.createUser(user, result.user.uid)));
  }

  Future<UserModel.User> getCurrentUser() {
    return _firestore.getUser(_firebaseAuth.currentUser?.uid);
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> singOut() async {
    await _firebaseAuth.signOut();
  }
}
