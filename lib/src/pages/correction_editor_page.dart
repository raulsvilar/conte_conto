import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';
import 'package:conte_conto/src/blocs/correction_editor_bloc.dart';

class CorrectionEditorPage extends StatefulWidget {
  final String _correctionID;
  final String _contoID;

  CorrectionEditorPage(this._contoID, this._correctionID);

  @override
  CorrectionEditorPageState createState() => CorrectionEditorPageState();
}

class CorrectionEditorPageState extends State<CorrectionEditorPage> {
  final _bloc = BlocProvider.getBloc<EditorCorrectionsBloc>();

  ZefyrController _controller;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _bloc.loadDocument(widget._correctionID, widget._contoID).then((document) {
      _controller = ZefyrController(document);
      _bloc.contoLoaded(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Correção"),
      ),
      body: StreamBuilder(
        stream: _bloc.isContoLoaded,
        builder: (context, isLoaded) {
          if (isLoaded.hasData && isLoaded.data) {
            return ZefyrScaffold(
              child: ZefyrEditor(
                padding: EdgeInsets.all(16),
                controller: _controller,
                focusNode: _focusNode,
                mode: ZefyrMode.view,
              ),
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
