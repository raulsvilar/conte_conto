import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/help_editor_bloc.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zefyr/zefyr.dart';

class HelpEditorPage extends StatefulWidget {
  final String name;
  final String turmaID;
  final String materialID;
  final bool readonly;
  final HelpEditorBloc bloc = BlocProvider.getBloc<HelpEditorBloc>();

  HelpEditorPage(this.name, this.turmaID, this.materialID, this.readonly);

  @override
  HelpEditorPageState createState() => HelpEditorPageState();
}

class HelpEditorPageState extends State<HelpEditorPage> {
  ZefyrController _controller;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget.bloc
        .loadDocument(widget.materialID, widget.turmaID)
        .then((document) {
      _controller = ZefyrController(document);
      widget.bloc.contoLoaded(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          actions: [
            if (!widget.readonly)
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  widget.bloc.saveDocument(
                      widget.turmaID, widget.name, _controller.document);
                  Fluttertoast.showToast(
                      msg: DESCRIPTION_SENDING, toastLength: Toast.LENGTH_LONG);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
        body: StreamBuilder(
            stream: widget.bloc.isContoLoaded,
            builder: (context, isLoaded) {
              if (isLoaded.hasData && isLoaded.data) {
                return ZefyrScaffold(
                  child: ZefyrEditor(
                      controller: _controller,
                      mode: widget.readonly ? ZefyrMode.view : ZefyrMode.edit,
                      focusNode: _focusNode),
                );
              } else
              return Center(child: CircularProgressIndicator());
            }));
  }
}
