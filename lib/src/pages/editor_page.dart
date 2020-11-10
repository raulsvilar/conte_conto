import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/editor_bloc.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:zefyr/zefyr.dart';

class EditorPage extends StatefulWidget {
  final String _contoID;
  final bool _canCreate;
  final _bloc = BlocProvider.getBloc<EditorBloc>();
  final bool isMaterial;
  final String materialName;

  EditorPage(this._contoID, this._canCreate,
      {this.isMaterial, this.materialName});

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  ZefyrController _controller;

  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    widget._bloc.loadDocument(widget._contoID).then((document) {
      _controller = ZefyrController(document);
      widget._bloc.contoLoaded(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget saveBtn = Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.save),
        onPressed: () => widget._bloc.saveDocument(widget._contoID,
            _controller.document, saveCallback, widget._canCreate),
      ),
    );

    final Widget finishBtn = Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.check),
        onPressed: () => widget._bloc
            .setContoFinished(widget._contoID, saveCallback, widget._canCreate)
            .then((document) {
          _controller = ZefyrController(document);
          widget._bloc.contoLoaded(true);
        }),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Editor"),
        actions: <Widget>[
          StreamBuilder(
            stream: widget._canCreate
                ? widget._bloc.inEditionForStudent
                : widget._bloc.inEditionForTeacher,
            builder: (_, snapshot) {
              if (snapshot.hasData && !snapshot.data) {
                return finishBtn;
              } else
                return Container();
            },
          ),
          StreamBuilder(
            stream:  widget._canCreate
                ? widget._bloc.inEditionForStudent
                : widget._bloc.inEditionForTeacher,
            builder: (_, snapshot) {
              if (snapshot.hasData && !snapshot.data) {
                return saveBtn;
              } else
                return Container();
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: widget._bloc.isContoLoaded,
        builder: (context, isLoaded) {
          if (isLoaded.hasData && isLoaded.data) {
            return ZefyrScaffold(
              child: StreamBuilder(
                stream: widget._canCreate
                    ? widget._bloc.inEditionForStudent
                    : widget._bloc.inEditionForTeacher,
                builder: (_, snapshot) {
                  if (snapshot.hasData && isLoaded.data) {
                    return ZefyrEditor(
                      toolbarDelegate: _ToolBarDelegate(widget._canCreate),
                      padding: EdgeInsets.all(16),
                      controller: _controller,
                      focusNode: _focusNode,
                      mode: snapshot.data ? ZefyrMode.view : ZefyrMode.edit,
                    );
                  } else
                    return Center(child: CircularProgressIndicator());
                },
              ),
            );
          } else
            return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void saveCallback() {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(DESCRIPTION_SAVED)));
  }
}

class _ToolBarDelegate extends ZefyrToolbarDelegate {
  bool _mode;

  _ToolBarDelegate(this._mode);

  final kDefaultButtonIcons = {
    ZefyrToolbarAction.bold: Icons.format_bold,
    ZefyrToolbarAction.italic: Icons.format_italic,
    ZefyrToolbarAction.link: Icons.link,
    ZefyrToolbarAction.unlink: Icons.link_off,
    ZefyrToolbarAction.clipboardCopy: Icons.content_copy,
    ZefyrToolbarAction.openInBrowser: Icons.open_in_new,
    ZefyrToolbarAction.heading: Icons.format_size,
    ZefyrToolbarAction.bulletList: Icons.format_list_bulleted,
    ZefyrToolbarAction.numberList: Icons.format_list_numbered,
    ZefyrToolbarAction.quote: Icons.format_quote,
    ZefyrToolbarAction.image: Icons.photo,
    ZefyrToolbarAction.cameraImage: Icons.photo_camera,
    ZefyrToolbarAction.galleryImage: Icons.photo_library,
    ZefyrToolbarAction.hideKeyboard: Icons.keyboard_hide,
    ZefyrToolbarAction.close: Icons.close,
    ZefyrToolbarAction.confirm: Icons.check,
  };

  final kDefaultButtonIconsMode = {
    ZefyrToolbarAction.code: Icons.code,
    ZefyrToolbarAction.horizontalRule: Icons.remove,
    ZefyrToolbarAction.highlight: Icons.highlight,
    ZefyrToolbarAction.link: Icons.link,
    ZefyrToolbarAction.unlink: Icons.link_off,
  };

  final kSpecialIconSizes = {
    ZefyrToolbarAction.unlink: 20.0,
    ZefyrToolbarAction.clipboardCopy: 20.0,
    ZefyrToolbarAction.openInBrowser: 20.0,
    ZefyrToolbarAction.close: 20.0,
    ZefyrToolbarAction.confirm: 20.0,
  };

  final kDefaultButtonTexts = {
    ZefyrToolbarAction.headingLevel1: 'H1',
    ZefyrToolbarAction.headingLevel2: 'H2',
    ZefyrToolbarAction.headingLevel3: 'H3',
  };

  @override
  Widget buildButton(BuildContext context, ZefyrToolbarAction action,
      {VoidCallback onPressed}) {
    final theme = Theme.of(context);
    if (!_mode) {
      if (kDefaultButtonIconsMode.containsKey(action)) {
        final icon = kDefaultButtonIconsMode[action];
        final size = kSpecialIconSizes[action];
        return ZefyrButton.icon(
          action: action,
          icon: icon,
          iconSize: size,
          onPressed: onPressed,
        );
      } else
        return Container();
    } else {
      if (kDefaultButtonIcons.containsKey(action)) {
        final icon = kDefaultButtonIcons[action];
        final size = kSpecialIconSizes[action];
        return ZefyrButton.icon(
          action: action,
          icon: icon,
          iconSize: size,
          onPressed: onPressed,
        );
      } else {
        if (kDefaultButtonTexts.containsKey(action)) {
          final text = kDefaultButtonTexts[action];
          assert(text != null);
          final style = theme.textTheme.caption
              .copyWith(fontWeight: FontWeight.bold, fontSize: 14.0);
          return ZefyrButton.text(
            action: action,
            text: text,
            style: style,
            onPressed: onPressed,
          );
        } else
          return Container();
      }
    }
  }
}
