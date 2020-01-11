import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/editor_bloc.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  final String _contoID;
  final bool _canEdit;

  EditorPage(this._contoID, this._canEdit);

  @override
  EditorPageState createState() => EditorPageState(_contoID, _canEdit ?  ZefyrMode.edit : ZefyrMode.select, _canEdit);
}

class EditorPageState extends State<EditorPage> {

  final String _contoID;
  final ZefyrMode _editorMode;
  final _canSave;

  final _bloc = BlocProvider.getBloc<EditorBloc>();

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  EditorPageState(this._contoID, this._editorMode, this._canSave);

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _bloc.loadDocument(_contoID).then((document) {
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
            mode: _editorMode,
            padding: EdgeInsets.all(16),
            controller: _controller,
            focusNode: _focusNode,
          ),
    );

    final Widget canSave = _canSave
        ? Builder(
            builder: (context) => IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _bloc.saveDocument(_contoID, _controller.document,
                saveCallback),
            ),
          )
        : Container();
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor page"),
        actions: <Widget>[
          canSave
        ],
      ),
      body: body,
    );
  }

  void saveCallback() {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(DESCRIPTION_SAVED)));
  }
}