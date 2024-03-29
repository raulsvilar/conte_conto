import 'package:cloud_firestore/cloud_firestore.dart';

class HelpMaterial {
  final String name;
  final String content;
  final Timestamp datetime;
  final DocumentReference reference;

  HelpMaterial.newHelpMaterial(this.name, this.content,
      {this.reference, this.datetime});

  HelpMaterial.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['content'] != null),
        content = map['content'],
        name = map['name'],
        datetime = map['datetime'];

  HelpMaterial.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['content'] = content;
    data['datetime'] = datetime;
    return data;
  }
}
