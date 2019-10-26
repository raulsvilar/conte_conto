import 'package:flutter/material.dart';

class CorrectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mensagem'),
      ),
      body: _buildBody(context),
    );
  }

  _buildBody(context) {
    return Container (
      margin: EdgeInsets.all(16),
      child: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: _buildCard(context),
      ),
    );
  }

  _buildCard(context) {
    TextEditingController toController = TextEditingController(text: 'Fulano');
    return Card(
      child: Container(
        margin: EdgeInsets.only(top: 16, bottom: 16),
        padding: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            TextField(
              readOnly: true,
              controller: toController,
            ),
            TextField(
              keyboardType: TextInputType.multiline,
              minLines: 5,
              maxLines: null,
            )
          ],
        ),
      ),
    );
  }


}