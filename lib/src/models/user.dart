import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String email;
  String fullName;
  String password;
  final DocumentReference reference;

  User.fromJson(Map<String, dynamic> json, this.reference) {
    email = json['email'];
    fullName = json['fullName'];
    password = json['password'];
  }

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['email'] != null),
        assert(map['fullName'] != null),
        assert(map['password'] != null),
        email = map['email'],
        fullName = map['fullName'],
        password = map['password'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['fullName'] = fullName;
    data['password'] = password;
    return data;
  }
}
