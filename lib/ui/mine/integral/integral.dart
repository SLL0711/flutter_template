import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/withdraw.dart';
import 'package:flutter_medical_beauty/ui/mine/integral/details.dart';
import 'package:flutter_medical_beauty/ui/profit/detail/hot.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api.dart';
import '../../../colors.dart';
import '../../../http.dart';
import '../../../toast.dart';

class IntegralScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IntegralScreenState();
}

class IntegralScreenState extends State<IntegralScreen>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  ScrollController _scrollController = ScrollController();
  List<String> _tabItems = ['积分明细', '现金明细'];
  GoldEntity _entity = GoldEntity();

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _init() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.beautyBalanceDetail, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = GoldEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _pushWithdraw() {
    NavigatorUtil.pushPage(context, GoldWithdrawScreen(_entity.allBalance));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildTabController() {
      return DefaultTabController(
        initialIndex: 0,
        length: _tabItems.length,
        child: Column(
          children: [
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
                    return DetailsScreen(index);
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () => {Navigator.pop(context)},
              icon: Image.asset(
                "assets/images/home/back.png",
                width: 28,
                height: 28,
              ),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        actions: [
          GestureDetector(
            onTap: () => {NavigatorUtil.pushPage(context, HotScreen())},
            child: Container(
              height: kToolbarHeight,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              alignment: Alignment.center,
              child: Text(
                '积分说明',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
          ),
        ],
        title: Text(
          'Star积分',
          style: TextStyle(
            fontSize: 18,
            color: XCColors.mainTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Stack(
                      children: [
                        Image.asset('assets/images/mine/mine_integral_bg.png'),
                        Positioned(
                          left: 24,
                          right: 15,
                          top: 23,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 62,
                                height: 22,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text(
                                  '当前收益',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${_entity.allBalance}',
                                    style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '元',
                                    style: TextStyle(
                                      height: 2.5,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  GestureDetector(
                                    onTap: _pushWithdraw,
                                    child: Container(
                                      width: 76,
                                      height: 28,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        '去提现',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '昨日收益+0.00元',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 32),
                                  Text(
                                    '累计收益0.00元',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            width: double.infinity,
                            height: 52,
                            color: Color(0x98FFFFFF),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(width: 24),
                                Text(
                                  '我的Star积分',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Image.asset(
                                  'assets/images/mine/mine_integral_icon.png',
                                  width: 16,
                                  height: 18,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '${_entity.withdrawBalance}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
        body: _buildTabController(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
