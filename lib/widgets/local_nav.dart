import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widgets/web_view.dart';

class LocalNav extends StatelessWidget {
  final List<CommonModel> list;

  const LocalNav({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (list == null) {
      return null;
    }
    List<Widget> items = [];
    list.forEach((model) {
      items.add(_item(context, model));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items,
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => WebView(
                  url: model.url,
                  statusBarColor: model.statusBarColor,
                  hideAppBar: model.hideAppBar,
                )));
      },
      child: Column(
        children: <Widget>[
          Image.network(
            model.icon,
            width: 32,
            height: 32,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
