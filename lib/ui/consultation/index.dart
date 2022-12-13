import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/consultation/list.dart';
import 'package:flutter_medical_beauty/ui/consultation/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';

import '../../event_center.dart';

/// 首页---咨询问答
class ConsultationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ConsultationScreenState();
}

class ConsultationScreenState extends State<ConsultationScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  ScrollController _scrollController = ScrollController();
  List<BannerEntity> _bannerInfo = <BannerEntity>[];
  List<TabEntity> _tabItems = <TabEntity>[];
  List<String> _sortList = ['咨询数', '关注数', '好评升序', '好评降序'];
  List<String> _filterList = ['高级咨询师', '咨询中', '在线', '离线'];
  int _sort = -1, _filter = -1;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    requestBannerInfo();
    requestTabInfo();
  }

  /// 请求轮播图
  void requestBannerInfo() async {
    Map<String, String> params = Map();
    params['type'] = '1';
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.banner, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          _bannerInfo.add(BannerEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  ///请求分类
  void requestTabInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.tab, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _tabItems.clear();
        http.data.forEach((element) {
          _tabItems.add(TabEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  ///排序筛选
  void sortOrFilter(int type) {
    // 滑动到指定位置
    double offsetY = 185;
    if (_scrollController.offset < offsetY) {
      _scrollController.animateTo(
        offsetY,
        duration: new Duration(milliseconds: 300), // 300ms
        curve: Curves.bounceIn,
      );
    }
    if (type == 1) {
      //筛选
      ConsultationWidgets.showActionDialog(
        context,
        _filter,
        _filterList,
        (index) => {
          this.setState(() {
            _filter = index == _filter ? -1 : index;
            EventCenter.defaultCenter()
                .fire(new RefreshConsultEvent(type, _filter));
          })
        },
      );
    } else {
      //排序
      ConsultationWidgets.showActionDialog(
        context,
        _sort,
        _sortList,
        (index) => {
          this.setState(() {
            _sort = index == _sort ? -1 : index;
            EventCenter.defaultCenter()
                .fire(new RefreshConsultEvent(type, _sort));
          })
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildTabController() {
      return DefaultTabController(
        length: _tabItems.length,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(
                top: 6,
                left: 16,
                right: 16,
              ),
              alignment: Alignment.center,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => {sortOrFilter(0)},
                    child: Text(
                      _sort == -1 ? '智能排序' : _sortList[_sort],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    'assets/images/video/ic_arrow_down.png',
                    width: 12,
                    height: 7,
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => {sortOrFilter(1)},
                    child: Text(
                      _filter == -1 ? '筛选' : _filterList[_filter],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Image.asset(
                    'assets/images/video/ic_arrow_down.png',
                    width: 12,
                    height: 7,
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 6),
              width: double.infinity,
              height: 38,
              child: _tabItems.isEmpty
                  ? Container()
                  : TabBar(
                      isScrollable: true,
                      labelColor: XCColors.tabSelectedColor,
                      unselectedLabelColor: XCColors.tabNormalColor,
                      labelStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      indicatorColor: Colors.white,
                      unselectedLabelStyle: TextStyle(fontSize: 12),
                      tabs: List<Widget>.generate(
                        _tabItems.length,
                        (index) {
                          TabEntity entity = _tabItems[index];
                          return Tab(text: entity.name);
                        },
                      ),
                    ),
            ),
            Expanded(
              child: _tabItems.isEmpty
                  ? Container()
                  : TabBarView(
                      children: List<Widget>.generate(
                        _tabItems.length,
                        (index) {
                          return ConsultationListView(
                            _tabItems[index].id,
                            _sort,
                            _filter,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: ConsultationWidgets.appBar(context, '咨询问答'),
      body: NestedScrollView(
        controller: _scrollController,
        body: _buildTabController(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ConsultationWidgets.header(context, _bannerInfo),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
