import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/collection/tabbar_view/diary.dart';
import 'package:flutter_medical_beauty/ui/mine/collection/tabbar_view/goods.dart';

class CollectionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionScreenState();
}

class CollectionScreenState extends State<CollectionScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['商品', '日记'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '我的收藏', () {
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
                    return CollectionGoodsScreen();
                  } else {
                    return CollectionDiaryScreen();
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
