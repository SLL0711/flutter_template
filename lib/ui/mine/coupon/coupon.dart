import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/coupon/category.dart';

class CouponScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CouponScreenState();
}

class CouponScreenState extends State<CouponScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['待使用', '已完成', '已过期'];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '优惠券', () {
          Navigator.pop(context);
        }),
        body: DefaultTabController(
          length: _tabItems.length,
          child: Column(
            children: [
              Container(
                height: 40,
                color: Colors.white,
                child: TabBar(
                  isScrollable: false,
                  labelColor: XCColors.bannerSelectedColor,
                  unselectedLabelColor: XCColors.tabNormalColor,
                  labelStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(fontSize: 16),
                  indicatorColor: XCColors.detailSelectedColor,
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
                  return CouponCategoryScreen(index);
                }),
              ))
            ],
          ),
        ));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
