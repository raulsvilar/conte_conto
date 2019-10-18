import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class Turmas extends StatefulWidget {
  @override
  _TurmasState createState() => _TurmasState();

}

class _TurmasState extends State<Turmas> {
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
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          print(lista[index]);

          return ItemWithImageTitleSub(lista[index], listaEscola[index]);
          },
        itemCount: lista.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: null,//_incrementCounter,
        tooltip: 'Adicionar',
        child: Icon(Icons.add)
      ),
    );
  }

}