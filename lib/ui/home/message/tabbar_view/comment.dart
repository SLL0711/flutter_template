import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/tool.dart';

import '../../../../colors.dart';
import 'comment_category.dart';

class CommentTabBarView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentTabBarViewState();
}

class CommentTabBarViewState extends State<CommentTabBarView>
    with AutomaticKeepAliveClientMixin {
  /// tab类别
  // List<String> _tabItems = ['商品', '日记', '咨询师', '商家', '问答'];
  List<String> _tabItems = ['商品', '日记', '咨询师', '商家'];

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    bool isGrounding = await Tool.isGrounding();
    if (isGrounding) {
      setState(() {
        _tabItems = ['商品', '日记', '技师', '门店'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(height: 1, color: XCColors.messageChatDividerColor),
            Expanded(
                child: DefaultTabController(
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
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(fontSize: 12),
                      indicatorColor: Colors.transparent,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List<Widget>.generate(_tabItems.length, (index) {
                        String title = _tabItems[index];
                        return Tab(text: title);
                      }),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children:
                          List<Widget>.generate(_tabItems.length, (index) {
                        return CommentCategoryView();
                      }),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
