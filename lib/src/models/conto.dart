import 'package:cloud_firestore/cloud_firestore.dart';

class Conto {
  final String title;
  final String author;
  final String owner;
  final DocumentReference reference;
  final String content;
  final bool isFavorited;
  final bool finished;
  final bool sendedForCorrection;
  final String teacherID;
  Timestamp creationDate;
  final String turmaID;

  Conto.newConto(this.title, this.author, this.owner,
      {this.teacherID,
      this.reference,
      this.content,
      this.sendedForCorrection = false,
      this.isFavorited = false,
      this.turmaID,
      this.finished = false,
      this.creationDate});

  Conto.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  Conto.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['author'] != null),
        assert(map['turmaID'] != null),
        assert(map['favorited'] != null),
        assert(map['author'] != null),
        assert(map['sendedForCorrection'] != null),
        assert(map['teacherID'] != null),
        turmaID = map['turmaID'],
        author = map['author'],
        owner = map['owner'],
        title = map['title'],
        sendedForCorrection = map['sendedForCorrection'],
        isFavorited = map['favorited'],
        creationDate = map['creationDate'],
        finished = map['finished'],
        teacherID = map['teacherID'],
        content = map['content'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['owner'] = owner;
    data['author'] = author;
    data['turmaID'] = turmaID;
    data['creationDate'] = creationDate;
    data['finished'] = finished;
    data['favorited'] = isFavorited;
    data['teacherID'] = teacherID;
    data['content'] = content;
    return data;
  }
}
