import 'package:cloud_firestore/cloud_firestore.dart';

class Conto {
  final String title;
  final String author;
  final String owner;
  final DocumentReference reference;
  final String content;
  final bool isFavorited;
  final String turmaID;

  Conto.newConto({this.title, this.author, this.owner, this.reference, this.content, this.isFavorited=false, this.turmaID});

  Conto.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Conto.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['author'] != null),
        assert(map['turmaID'] != null),
        assert(map['favorited'] != null),
        assert(map['author'] != null),
        turmaID = map['turmaID'],
        author = map['author'],
        owner = map['owner'],
        title = map['title'],
        isFavorited = map['favorited'],
        content = map['content'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['owner'] = owner;
    data['turmaID'] = turmaID;
    data['favorited'] = isFavorited;
    data['content'] = content;
    return data;
  }

}