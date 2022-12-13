import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/profit/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api.dart';
import '../../event_center.dart';
import '../../http.dart';
import '../../toast.dart';
import '../../user.dart';

class ProfitScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ProfitScreenState();
}

class ProfitScreenState extends State<ProfitScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _mineEvent, _logoutEvent;
  bool _isLogin = false, _isGrounding = false;
  MineEntity _entity = MineEntity();

  @override
  void dispose() {
    _refreshController.dispose();
    _mineEvent.cancel();
    _logoutEvent.cancel();
    super.dispose();
  }

  @override
  void initState() {
    _mineEvent =
        EventCenter.defaultCenter().on<RefreshMineEvent>().listen((event) {
      _init();
    });
    _logoutEvent =
        EventCenter.defaultCenter().on<LogoutEvent>().listen((event) {
      _init();
    });
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _isLogin = await UserManager.isLogin();
    if (_isLogin) {
      // 请求
      _requestUserInfo();
    } else {
      setState(() {
        _entity = MineEntity();
      });
      _refreshController.refreshCompleted();
    }
  }

  /// 请求时间
  void _requestUserInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = MineEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
    _refreshController.refreshCompleted();
  }

  ///热力值兑换
  void _exchangePower(int value) async {
    Map<String, dynamic> params = Map();
    params['exchangeValue'] = value;
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.powerExchange, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity.heatingPowerValue = (_entity.heatingPowerValue ?? 0) - value;
        EventCenter.defaultCenter().fire(RefreshMineEvent('热力值改变'));
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.black,
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/profit/profit_header_bg.png'),
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      backgroundColor: XCColors.homeDividerColor,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _init,
        header: MaterialClassicHeader(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ProfitWidgets.profitHeaderView(context, _entity, _isGrounding),
              Container(
                margin: EdgeInsets.only(top: 89),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 14),
                    ProfitWidgets.profitFriendsView(
                      context,
                      _entity,
                      _isGrounding,
                    ),
                    SizedBox(height: 10),
                    ProfitWidgets.profitHotView(context, _entity, () {
                      _exchangePower(15);
                    }),
                    SizedBox(height: 10),
                    ProfitWidgets.profitShareView(context, _entity),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
