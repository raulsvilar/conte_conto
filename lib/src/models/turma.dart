import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  final String name;
  final String school;
  final DocumentReference reference;

  Turma.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['school'] != null),
        name = map['name'],
        school = map['school'];

  Turma.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Turma<$name:$school>";
}