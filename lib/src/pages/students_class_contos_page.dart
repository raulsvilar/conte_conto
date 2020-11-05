import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conte_conto/src/blocs/students_class_contos_bloc.dart';
import 'package:conte_conto/src/models/conto.dart';
import 'package:conte_conto/src/pages/base/contos_list.dart';
import 'package:conte_conto/src/pages/base/items.dart';
import 'package:flutter/material.dart';

class StudentsClassContosPage extends ContosListBase<StudentsClassContosBloc> {
  StudentsClassContosPage() : super();

  @override
  List<Widget> appBarActions(BuildContext context) {
    return null;
  }

  @override
  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    List<DocumentSnapshot> items = snapshot
        .where((item) => item.data()["owner"] != bloc.user.reference.id)
        .toList();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        return super.buildListItem(context, items[index]);
      },
    );
  }

  @override
  ItemWithImageTitleSub configItem(Conto conto) {
    return ItemWithImageTitleSub(
        itemID: conto.reference.id,
        title: conto.title,
        subTitle: conto.author,
        onTapCallback: onTapConto);
  }

  @override
  onPressedFloatingActionButton(BuildContext context) {
    return null;
  }
}
