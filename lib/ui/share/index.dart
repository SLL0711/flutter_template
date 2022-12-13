import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/member/member.dart';
import 'package:flutter_medical_beauty/ui/share/entity.dart';
import 'package:flutter_medical_beauty/ui/share/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../api.dart';
import '../../event_center.dart';
import '../../http.dart';
import '../../toast.dart';
import '../../user.dart';

/// 分享
class ShareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ShareScreenState();
}

class ShareScreenState extends State<ShareScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _mineEvent, _logoutEvent;
  bool _isLogin = false, _isGrounding = false;
  MineEntity _entity = MineEntity();
  List<ShareConfigEntity> _shareConfigList = [];

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
    _requestShareConfig();
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

  /// 请求用户信息
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

  /// 请求分享配置
  void _requestShareConfig() async {
    var http = await HttpManager.get(DsApi.shareConfigList, context);
    if (http.code == 200) {
      setState(() {
        _shareConfigList = [];
        http.data.forEach((item) {
          _shareConfigList.add(ShareConfigEntity.fromJson(item));
        });
      });
    }
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
      appBar: ShareWidgets.appBar(context),
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _init,
        header: MaterialClassicHeader(),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ShareWidgets.headView(context, _entity, _isGrounding),
              Container(
                margin: EdgeInsets.only(top: 96),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    ShareWidgets.sectionTitle(context, "会员权益"),
                    SizedBox(height: 10),
                    ShareWidgets.membershipInterests(context),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {
                        NavigatorUtil.pushPage(context, MemberLevelScreen())
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          left: 16,
                          top: 15,
                          right: 16,
                        ),
                        width: double.infinity,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                          border: Border.all(
                            color: XCColors.mainTextColor,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '了解更多',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: XCColors.mainTextColor,
                          ),
                        ),
                      ),
                    ),
                    ShareWidgets.sectionTitle(context, "分享赢积分"),
                    SizedBox(height: 20),
                    ShareWidgets.shareEarn(context, _entity, _shareConfigList, _exchangePower),
                    ShareWidgets.sectionTitle(context, "立即分享"),
                    SizedBox(height: 20),
                    ShareWidgets.nowShare(context),
                    SizedBox(height: 40),
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
