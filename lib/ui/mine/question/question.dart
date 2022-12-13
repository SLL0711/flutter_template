import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/question/tabbar_view/answer.dart';
import 'package:flutter_medical_beauty/ui/mine/question/tabbar_view/problem.dart';
import 'package:flutter_medical_beauty/ui/mine/question/tabbar_view/recommend.dart';

class QuestionScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => QuestionScreenState();
}

class QuestionScreenState extends State<QuestionScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  List<String> _tabItems = ['我的提问', '我的回答', '推荐问题'];

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '互动回答', () {
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
                  if (index == 0) {
                    return QuestionProblemScreen();
                  } else if (index == 1) {
                    return QuestionAnswerScreen();
                  } else {
                    return QuestionRecommendScreen();
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
