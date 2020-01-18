import 'package:cloud_firestore/cloud_firestore.dart';

class Correction {
  final String content;
  final Timestamp datetime;
  final DocumentReference reference;

  Correction.newCorrection(this.content,
      {this.reference, this.datetime});

  Correction.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['content'] != null),
        content = map['content'],
        datetime = map['datetime'];

  Correction.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = content;
    data['datetime'] = datetime;
    return data;
  }
}
