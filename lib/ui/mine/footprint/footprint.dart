import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/tabbar_view/diary.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/tabbar_view/doctor.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/tabbar_view/goods.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/tabbar_view/hospital.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';

import '../../../tool.dart';

class FootprintScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FootprintScreenState();
}

class FootprintScreenState extends State<FootprintScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['商品', '日记', '商家', '咨询师'];

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    bool isGrounding = await Tool.isGrounding();
    if (isGrounding) {
      setState(() {
        _tabItems = ['商品', '日记', '门店', '技师'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: FootprintWidgets.footprintAppbar(context, '我的足迹', () {
          Navigator.pop(context);
        }),
        body: DefaultTabController(
          length: _tabItems.length,
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  height: 1,
                  color: XCColors.homeDividerColor),
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
                  if (index == 0) {
                    return FootprintGoodsScreen();
                  } else if (index == 1) {
                    return FootprintDiaryScreen();
                  } else if (index == 2) {
                    return FootprintHospitalScreen();
                  } else {
                    return FootprintDoctorScreen();
                  }
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
