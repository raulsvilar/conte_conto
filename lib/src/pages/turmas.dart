import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/models/turma.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class TurmasPage extends StatefulWidget {
  @override
  _TurmasPageState createState() => _TurmasPageState();

}

class _TurmasPageState extends State<TurmasPage> {
  final int count = 0;
  List<String> listaEscola = ['Escola A', 'Escola B', 'Escola C'];
  List<String> lista  = ['Turma 1', 'Turma 2',
    'Turma 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Turmas"),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: null,//_incrementCounter,
        tooltip: 'Adicionar',
        child: Icon(Icons.add)
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('turmas').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildListItem(context, snapshot[index]);
        });
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Turma.fromSnapshot(data);
    return ItemWithImageTitleSub(record.name, record.school);
  }
}