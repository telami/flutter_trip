import 'package:flutter/material.dart';
import 'package:flutter_trip/api/search_api.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widgets/search_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String showText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SearchBar(
            hideLeft: true,
            defaultText: 'hhh',
            hint: '132',
            leftButtonClick: () {
              Navigator.pop(context);
            },
            onChanged: _onTextChange,
          ),
          InkWell(
            onTap: () {
              SearchApi.fetch(
                      'https://m.ctrip.com/restapi/h5api/globalsearch/search?userid=M2208559994&source=mobileweb&action=mobileweb&keyword=天津')
                  .then((SearchModel value) {
                setState(() {
                  showText = value.data[0].url;
                });
              });
            },
            child: Text('Get'),
          ),
          Text(showText)
        ],
      ),
    );
  }

  _onTextChange(String text) {}
}
