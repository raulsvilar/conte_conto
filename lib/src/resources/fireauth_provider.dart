import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'dart:async';

class Authentication {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirestoreProvider();

  Future<User> signIn(String email, String password) async {
    DocumentSnapshot ds = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ).then((result) => _firestore.getUser(result.user.uid));
    return User.fromSnapshot(ds);
  }

  Future<User> signUp(User user) async {
    DocumentReference result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password,
    ).then(((result) => _firestore.createUser(user, result.user.uid)));
    return User.fromJson(user.toJson(), result);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> singOut() async {
    await _firebaseAuth.signOut();
  }

}
