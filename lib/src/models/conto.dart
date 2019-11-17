import 'package:cloud_firestore/cloud_firestore.dart';

class Conto {
  final String title;
  final String author;
  final DocumentReference reference;
  final DocumentReference content;
  final bool isFavorited;
  final String turma;

  Conto.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Conto.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['author'] != null),
        assert(map['turma'] != null),
        assert(map['favorited'] != null),
        turma = map['turma'],
        author = map['author'],
        title = map['title'],
        isFavorited = map['favorited'],
        content = map['content'];

}

class _Content {

}