import 'package:cloud_firestore/cloud_firestore.dart';

class Turma {
  final String name;
  final String school;
  final String owner;
  final List<String> members;
  final List<String> contos_publicados;
  final DocumentReference reference;

  Turma.newTurma(this.name, this.school, this.owner,
      {this.reference, this.members = const [], this.contos_publicados = const []});

  Turma.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['school'] != null),
        assert(map['owner'] != null),
        assert(map['members'] != null),
        assert(map['contos_publicados'] != null),
        owner = map['owner'],
        name = map['name'],
        school = map['school'],
        members = List.from(map['members']),
        contos_publicados = List.from(map['contos_publicados']);

  Turma.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['school'] = school;
    data['owner'] = owner;
    data['members'] = members;
    data['contos_publicados'] = contos_publicados;
    return data;
  }

  @override
  String toString() => "Turma<$name:$school>";
}
