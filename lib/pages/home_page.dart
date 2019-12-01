import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/api/home_api.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/widgets/grid_nav.dart';
import 'package:flutter_trip/widgets/local_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    "https://dimg03.c-ctrip.com/images/10020q000000gajaeDB6E_C_750_420_Q90.jpg",
    "https://dimg03.c-ctrip.com/images/200f0v000000k0r3361EC_C_750_420_Q90.jpg",
    "https://dimg03.c-ctrip.com/images/200j0t000000ih4ttD0C5_C_750_420_Q90.jpg",
  ];

  double appBarAlpha = 0;

  List<CommonModel> localNavList;

  GridNavModel gridNav;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: NotificationListener(
                  // ignore: missing_return
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 160,
                        child: Swiper(
                          itemCount: _imageUrls.length,
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(_imageUrls[index],
                                fit: BoxFit.fill);
                          },
                          pagination: SwiperPagination(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        child: LocalNav(
                          list: localNavList,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                        child: GridNavWidget(
                          gridNav: gridNav,
                        ),
                      )
                    ],
                  ),
                )),
            Opacity(
                opacity: appBarAlpha,
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text('首页'),
                    ),
                  ),
                )),
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    HomeModel home = await HomeApi.fetch();
    setState(() {
      localNavList = home.localNavList;
      gridNav = home.gridNav;
    });
  }

  _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
  }
}
