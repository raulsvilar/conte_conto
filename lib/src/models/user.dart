import 'package:cloud_firestore/cloud_firestore.dart';

enum userTypes {
  student,
  teacher
}

class User {
  String email;
  String name;
  String password;
  String turmaID;
  userTypes type;

  final DocumentReference reference;

  User.fromJson(Map<String, dynamic> json, this.reference) {
    email = json['email'];
    name = json['name'];
    password = json['password'];
    turmaID = json['turmaID'];
    type = userTypes.values[json['type']];
  }

  User.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['email'] != null),
        assert(map['name'] != null),
        assert(map['password'] != null),
        assert(map['turmaID'] != null),
        assert(map['type'] != null),
        email = map['email'],
        name = map['name'],
        turmaID = map['turmaID'],
        type = userTypes.values[map['type']],
        password = map['password'];

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['turmaID'] = turmaID;
    data['type'] = type.index;
    return data;
  }
}
