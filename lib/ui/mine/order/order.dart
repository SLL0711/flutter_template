import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/order/category.dart';

class MineOrderScreen extends StatefulWidget {
  final int initialIndex;

  MineOrderScreen(this.initialIndex);

  @override
  State<StatefulWidget> createState() => MineOrderScreenState();
}

class MineOrderScreenState extends State<MineOrderScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['待支付', '待使用', '待评价', '待写日记', '已完成'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '我的订单', () {
        Navigator.pop(context);
      }),
      body: DefaultTabController(
        initialIndex: widget.initialIndex,
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
                isScrollable: true,
                labelColor: XCColors.bannerSelectedColor,
                unselectedLabelColor: XCColors.tabNormalColor,
                labelStyle:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontSize: 14),
                indicatorColor: XCColors.detailSelectedColor,
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: List<Widget>.generate(
                  _tabItems.length,
                  (index) {
                    String title = _tabItems[index];
                    return Tab(text: title);
                  },
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: List<Widget>.generate(
                  _tabItems.length,
                  (index) {
                    return OrderCategoryScreen(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
