import 'package:conte_conto/src/pages/base/bottom_navigation.dart';
import 'package:flutter/material.dart';

class ContosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Contos"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: null,
      ),
        bottomNavigationBar: BottomNavigation(
        [Items.library, Items.favorites, Items.messages],
            (index) => {}),
      body: _buildBody(context),
    );
  }

  _buildBody(BuildContext context) {

  }

}