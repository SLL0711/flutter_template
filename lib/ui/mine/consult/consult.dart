import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/consult/consult_list.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';

/// 咨询订单
class ConsultScreen extends StatefulWidget {
  final int initialIndex;
  final MineEntity userInfo;

  ConsultScreen(this.userInfo, {this.initialIndex = 0});

  @override
  State<StatefulWidget> createState() => ConsultScreenState();
}

class ConsultScreenState extends State<ConsultScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['未完成咨询', '已完成咨询', '已取消咨询'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '咨询订单', () {
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
              color: XCColors.homeDividerColor,
            ),
            Container(
              height: 45,
              color: Colors.white,
              child: TabBar(
                labelColor: XCColors.bannerSelectedColor,
                unselectedLabelColor: XCColors.tabNormalColor,
                labelStyle: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 15),
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
                    return ConsultListScreen(index, widget.userInfo);
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
