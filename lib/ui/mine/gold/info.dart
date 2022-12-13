import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/category.dart';

class GoldInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GoldInfoScreenState();
}

class GoldInfoScreenState extends State<GoldInfoScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['全部', '收入', '支出'];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '颜值金明细', () {
          Navigator.pop(context);
        }),
        body: DefaultTabController(
          length: _tabItems.length,
          child: Column(
            children: [
              Container(
                height: 52,
                color: XCColors.homeDividerColor,
                child: TabBar(
                  isScrollable: false,
                  labelColor: XCColors.bannerSelectedColor,
                  unselectedLabelColor: XCColors.tabNormalColor,
                  labelStyle:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontSize: 14),
                  indicatorColor: XCColors.bannerSelectedColor,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: List<Widget>.generate(_tabItems.length, (index) {
                    String title = _tabItems[index];
                    return Tab(text: title);
                  }),
                ),
              ),
              Expanded(
                  child: TabBarView(
                    children: List<Widget>.generate(_tabItems.length, (index) {
                      return GoldInfoCategoryScreen();
                    }),
                  ))
            ],
          ),
        )
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
