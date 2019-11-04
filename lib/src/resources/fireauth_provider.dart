import 'package:firebase_auth/firebase_auth.dart';
import 'package:conte_conto/src/resources/firestore_provider.dart';
import 'dart:async';

class Authentication {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirestoreProvider();

  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result?.user;
  }

  Future<FirebaseUser> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((result) => _firestore.addUserToDatabase(result.user));
    return result?.user;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> singOut() async {
    await _firebaseAuth.signOut();
  }

}
