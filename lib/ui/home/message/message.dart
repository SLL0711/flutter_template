import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/message/tabbar_view/chat.dart';
import 'package:flutter_medical_beauty/ui/home/message/tabbar_view/comment.dart';
import 'package:flutter_medical_beauty/ui/home/message/tabbar_view/notice.dart';
import 'package:flutter_medical_beauty/ui/home/message/tabbar_view/praise.dart';

class MessageScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  // List<String> _tabItems = ['私信', '评论', '点赞',  '通知'];
  List<String> _tabItems = ['私信',  '通知'];
  int _initIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '消息', () {
        Navigator.pop(context);
      }),
      body: DefaultTabController(
        initialIndex: _initIndex,
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
                indicatorColor: XCColors.bannerSelectedColor,
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
                    /// TODO 先仅有通知模块
                    if (index == 3) {
                      return NoticeTabBarView();
                    } else if (index == 1) {
                      // return CommentTabBarView();
                      return NoticeTabBarView();
                    } else if (index == 2) {
                      return PraiseTabBarView();
                    } else {
                      return ChatTabBarView();
                    }
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
