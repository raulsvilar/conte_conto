import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:conte_conto/src/blocs/students_class_contos_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:conte_conto/src/utils/constants.dart';
import 'package:flutter/material.dart';

class StudentsClassContosPage extends StatelessWidget {
  final StudentsClassContosBloc bloc =
      BlocProvider.getBloc<StudentsClassContosBloc>();

  Widget buildList(BuildContext context, List<Conto> snapshot) {
    return ListView.builder(
      itemCount: snapshot.length,
      itemBuilder: (BuildContext context, int index) {
        return buildListItem(snapshot[index]);
      },
    );
  }

  ItemWithImageTitleSub buildListItem(Conto conto) {
    return ItemWithImageTitleSub(
        itemID: conto.reference.id,
        title: conto.title,
        subTitle: conto.author,
        onTapCallback: onTapConto);
  }

  onTapConto(List args) {
    Navigator.of(args[0])
        .pushNamed(DESCRIPTION_EDITOR_PAGE, arguments: [args[1], true]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(DESCRIPTION_PUBLISHED_CONTOS),
      ),
      body: FutureBuilder(
        future: bloc.contosList(bloc.user.turmaID),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(
              child: Text(DESCRIPTION_NO_CONTOS_IN_CLASS),
            );
          if (!snapshot.hasData) return LinearProgressIndicator();
          if (snapshot.data.length > 0)
            return buildList(context, snapshot.data);
          else
            return Center(
              child: Text(DESCRIPTION_NO_CONTOS_IN_CLASS),
            );
        },
      ),
    );
  }
}
