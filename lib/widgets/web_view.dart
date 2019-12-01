import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLS = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class WebView extends StatefulWidget {
  final String url;
  final String statusBarColor;
  final String title;
  final bool hideAppBar;
  final bool backForbid;

  WebView(
      {this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false});

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webviewReference = FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onError;
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    webviewReference.close();
    _onUrlChanged = webviewReference.onUrlChanged.listen((String url) {});
    _onStateChanged =
        webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.startLoad:
          if (_isToMain(state.url) && !exiting) {
            if (widget.backForbid ?? false) {
              webviewReference.launch(widget.url);
            } else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    _onError = webviewReference.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  ///判断是否返回携程的页面
  _isToMain(String url) {
    bool contain = false;
    for (var value in CATCH_URLS) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    _onError.cancel();
    webviewReference.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor =
        statusBarColorStr == "ffffff" ? Colors.black : Colors.white;
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          Expanded(
              child: WebviewScaffold(
            url: widget.url,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: Colors.white,
              child: Center(child: CircularProgressIndicator()),
            ),
          )),
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      color: backgroundColor,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(
                  Icons.close,
                  color: backButtonColor,
                  size: 26,
                ),
              ),
            ),
            Positioned(
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
              left: 0,
              right: 0,
            )
          ],
        ),
      ),
    );
  }
}
