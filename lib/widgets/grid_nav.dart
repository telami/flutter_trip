import 'package:flutter/material.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';

class GridNavWidget extends StatelessWidget {
  final GridNavModel gridNav;

  const GridNavWidget({Key key, this.gridNav}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[_gridNavItems(context)],
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNav == null) {
      return items;
    }
    if (gridNav.hotel != null) {}
    if (gridNav.flight != null) {}
    if (gridNav.travel != null) {}
  }

  _gridNavItem(BuildContext context, Grid) {}
}
