import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  final String name;
  final String school;
  final String owner;
  final List<String> members;
  final DocumentReference reference;

  Turma.newTurma(this.name, this.school, this.owner,
      {this.reference, this.members = const []});

  Turma.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['school'] != null),
        assert(map['owner'] != null),
        assert(map['members'] != null),
        owner = map['owner'],
        name = map['name'],
        school = map['school'],
        members = List.from(map['members']);

  Turma.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['school'] = school;
    data['owner'] = owner;
    data['members'] = members;
    return data;
  }

  @override
  String toString() => "Turma<$name:$school>";
}
