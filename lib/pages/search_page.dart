import 'package:flutter/material.dart';
import 'package:flutter_trip/api/search_api.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/widgets/search_bar.dart';

const URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?userid=M2208559994&source=mobileweb&action=mobileweb&keyword=';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage(
      {Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyword;
  SearchModel searchModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(),
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
              flex: 1,
              child: ListView.builder(
                itemBuilder: (BuildContext context, int position) {
                  return _item(position);
                },
                itemCount: searchModel?.data?.length ?? 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  _onTextChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    var url = widget.searchUrl + keyword;
    SearchApi.fetch(url).then((SearchModel model) {
      setState(() {
        searchModel = model;
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        ),
      ],
    );
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) {
      return null;
    }
    SearchItem item = searchModel.data[position];
    return Text(item.word);
  }
}
