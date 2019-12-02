import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/widgets/web_view.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> list;

  const SubNav({Key key, this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
    int separate = (list.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(separate),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel model) {
    return Expanded(
        flex: 1,
        child: GestureDetector(
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
                width: 20,
                height: 20,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                model.title,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ));
  }
}
