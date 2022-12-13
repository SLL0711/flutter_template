import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/mine/fans/category.dart';

class FansScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FansScreenState();
}

class FansScreenState extends State<FansScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['关注', '粉丝'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return DefaultTabController(
        length: _tabItems.length,
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                leading: Builder(builder: (BuildContext context) {
                  return IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/images/home/back.png",
                          width: 28, height: 28),
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip);
                }),
                title: TabBar(
                    isScrollable: false,
                    labelColor: XCColors.bannerSelectedColor,
                    unselectedLabelColor: XCColors.tabNormalColor,
                    labelStyle:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontSize: 16),
                    indicatorColor: XCColors.bannerSelectedColor,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: List<Widget>.generate(_tabItems.length, (index) {
                      String title = _tabItems[index];
                      return Tab(text: title);
                    }))),
            body: Column(children: [
              Container(height: 10, color: XCColors.homeDividerColor),
              Expanded(
                  child: TabBarView(
                      children:
                          List<Widget>.generate(_tabItems.length, (index) {
                return FansCategoryView(index);
              })))
            ])));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
