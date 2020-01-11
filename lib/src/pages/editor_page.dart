import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/editor_bloc.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyr/zefyr.dart';
import 'dart:convert';

class EditorPage extends StatefulWidget {
  final String _contoID;

  EditorPage(this._contoID);

  @override
  EditorPageState createState() => EditorPageState(_contoID);
}

class EditorPageState extends State<EditorPage> {

  final String _contoID;

  final _bloc = BlocProvider.getBloc<EditorBloc>();

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  EditorPageState(this._contoID);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // If _controller is null we show Material Design loader, otherwise
    // display Zefyr editor.
    final Widget body = (_controller == null)
        ? Center(child: CircularProgressIndicator())
        : ZefyrScaffold(
      child: ZefyrEditor(
        padding: EdgeInsets.all(16),
        controller: _controller,
        focusNode: _focusNode,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _saveDocument(context),
            ),
          )
        ],
      ),
      body: body,
    );
  }

  Future<NotusDocument> _loadDocument() async {
    String content = await _bloc.getContoContent(_contoID).catchError((e) => "");
    if (content.isNotEmpty) {
      return NotusDocument.fromJson(jsonDecode(content));
    }
    final Delta delta = Delta()..insert(DESCRIPTION_EMPTY_CONTO);
    return NotusDocument.fromDelta(delta);
  }

  void _saveDocument(BuildContext context) {

    final contents = jsonEncode(_controller.document);

    _bloc.saveConto(_contoID, contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(DESCRIPTION_SAVED)));
    });
  }
}