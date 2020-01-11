import 'package:conte_conto/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'dart:async';

class Authentication {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirestoreProvider();

  Future<User> signIn(String email, String password) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((result) => _firestore.getUser(result.user.uid));
  }

  Future<User> signUp(User user) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,)
        .catchError((error) => print(error.toString()))
        .then(((result) => _firestore.createUser(user, result.user.uid)));
  }

  Future<User> getCurrentUser() async {
    return await _firebaseAuth.currentUser()
        .then( (userResult) => _firestore.getUser(userResult?.uid));
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> singOut() async {
    await _firebaseAuth.signOut();
  }

}
