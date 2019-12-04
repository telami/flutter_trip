import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/api/home_api.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/widgets/grid_nav.dart';
import 'package:flutter_trip/widgets/loading_container.dart';
import 'package:flutter_trip/widgets/local_nav.dart';
import 'package:flutter_trip/widgets/sales_box.dart';
import 'package:flutter_trip/widgets/sub_nav.dart';
import 'package:flutter_trip/widgets/web_view.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;

  List<CommonModel> localNavList;

  List<CommonModel> bannerList = [];

  GridNavModel gridNav;

  List<CommonModel> subNavList;

  SalesBoxModel salesBox;

  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: LoadingContainer(
            isLoading: _loading,
            child: Stack(
              children: <Widget>[
                MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: RefreshIndicator(
                      onRefresh: _handleRefresh,
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
                                itemCount: bannerList.length,
                                autoplay: true,
                                itemBuilder: (BuildContext context, int index) {
                                  var banner = bannerList[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => WebView(
                                            url: banner.url,
                                            statusBarColor: banner.statusBarColor,
                                            hideAppBar: banner.hideAppBar,
                                          )));
                                    },
                                    child: Image.network(banner.icon,
                                        fit: BoxFit.fill),
                                  );
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
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                              child: SubNav(
                                list: subNavList,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                              child: SalesBox(
                                salesBox: salesBox,
                              ),
                            )
                          ],
                        ),
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
            )));
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel home = await HomeApi.fetch();
      setState(() {
        localNavList = home.localNavList;
        bannerList = home.bannerList;
        gridNav = home.gridNav;
        subNavList = home.subNavList;
        salesBox = home.salesBox;
        _loading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
      });
    }
    return null;
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
