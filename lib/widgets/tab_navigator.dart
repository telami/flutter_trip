import 'package:flutter/material.dart';
import 'package:flutter_trip/pages/explore_page.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/message_page.dart';
import 'package:flutter_trip/pages/my_page.dart';

//底部导航框架
class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;

  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[HomePage(), ExplorePage(), MessagePage(), MyPage()],
      ),
      bottomNavigationBar: BottomNavigationBar(
          unselectedFontSize: 14,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            _controller.jumpToPage(index);
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            _bottomItem('首页', Icons.home, 0),
            _bottomItem('发现', Icons.explore, 1),
            _bottomItem('搜索', Icons.search, 2),
            _bottomItem('我的', Icons.person, 3),
          ]),
    );
  }

  _bottomItem(String title, IconData icon, int index) {
    return BottomNavigationBarItem(
        icon: Icon(
          icon,
          color: _defaultColor,
        ),
        activeIcon: Icon(
          icon,
          color: _activeColor,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 10,
              color: _currentIndex == index ? _activeColor : _defaultColor),
        ));
  }
}
