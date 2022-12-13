import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen(this.url);

  @override
  State<StatefulWidget> createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '详情', () {
        Navigator.pop(context);
      }),
      body: WebView(
        initialUrl: widget.url,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
