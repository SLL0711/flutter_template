import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/widgets.dart';

import '../../../colors.dart';

class PosterCreateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PosterCreateScreenState();
}

class PosterCreateScreenState extends State<PosterCreateScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 5, vsync: this);
  PageController _pageController = PageController();

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);

    /// 初始页面 指定
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '编辑海报', () {
          Navigator.pop(context);
        }),
        body: Column(children: [
          Expanded(
              child: PageView.builder(
            controller: _pageController,
            itemCount: 5,
            itemBuilder: (context, index) {
              return PosterWidgets.editPosterWidget(context);
            },
            onPageChanged: (index) {
              /// 要到新页面的时候 把新页面的index给我们
              _tabController.animateTo(index);
            },
          )),
          Container(
            height: 104,
            margin: const EdgeInsets.only(bottom: 50),
            child: XCPageSelector(
              controller: _tabController,
              color: XCColors.bannerNormalColor,
              selectedColor: XCColors.bannerSelectedColor,
              indicatorSize: 4,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: 50,
            color: XCColors.bannerSelectedColor,
            child: Text('生成海报',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          )
        ]));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
