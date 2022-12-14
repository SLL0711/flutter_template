import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/message/message.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/bean.dart';
import 'package:flutter_medical_beauty/ui/mine/consult/consult.dart';
import 'package:flutter_medical_beauty/ui/mine/coupon/coupon.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/diary.dart';
import 'package:flutter_medical_beauty/ui/mine/fans/fans.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/footprint.dart';
import 'package:flutter_medical_beauty/ui/mine/free/free.dart';
import 'package:flutter_medical_beauty/ui/mine/info/info.dart';
import 'package:flutter_medical_beauty/ui/mine/integral/integral.dart';
import 'package:flutter_medical_beauty/ui/mine/invoice/invoice.dart';
import 'package:flutter_medical_beauty/ui/mine/member/member.dart';
import 'package:flutter_medical_beauty/ui/mine/member/open.dart';
import 'package:flutter_medical_beauty/ui/mine/order/order.dart';
import 'package:flutter_medical_beauty/ui/mine/question/question.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/setting.dart';
import 'package:flutter_medical_beauty/ui/mine/sign/sign.dart';
import 'package:flutter_medical_beauty/ui/mine/store/settle.dart';
import 'package:flutter_medical_beauty/ui/mine/widgets.dart';
import 'package:flutter_medical_beauty/ui/video/video_order.dart';
import 'package:flutter_medical_beauty/user.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../tool.dart';
import 'collection/collection.dart';
import 'entity.dart';

/// 我的界面
class MyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> with AutomaticKeepAliveClientMixin {
  /// 变量
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _mineStatusEvent, _logoutEvent;
  MineEntity _entity = MineEntity();

  bool _isGrounding = true;

  // 0 未登录 1 普通用户 2 黄金会员 3 白金会员 4 钻石会员 5 钻石会员
  int _memberType = 0;

  @override
  void dispose() {
    _refreshController.dispose();
    _mineStatusEvent.cancel();
    _logoutEvent.cancel();
    if (_entity.doctorId != 0) {
      _updateDoctorStatus(0);
    }
    super.dispose();
  }

  @override
  void initState() {
    _mineStatusEvent =
        EventCenter.defaultCenter().on<RefreshMineEvent>().listen((event) {
      _init();
    });
    _logoutEvent =
        EventCenter.defaultCenter().on<LogoutEvent>().listen((event) {
      if (_entity.doctorId != 0) {
        _updateDoctorStatus(0);
      }
      _defaultStatus();
    });
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    bool isLogin = await UserManager.isLogin();
    if (isLogin) {
      // 请求
      _requestUserInfo();
    } else {
      // 默认状态
      _defaultStatus();
    }
  }

  void _defaultStatus() {
    setState(() {
      _entity = MineEntity();
      _memberType = 0;
    });
    _refreshController.refreshCompleted();
  }

  /// 请求时间
  void _requestUserInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = MineEntity.fromJson(http.data);
        _memberType = _entity.memberLevelId!;
      });
      if (_entity.doctorId != 0) {
        _updateDoctorStatus(1);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
    _refreshController.refreshCompleted();
  }

  /// 修改医生状态 咨询状态 0离线 1在线 2咨询中
  void _updateDoctorStatus(int status) {
    Map<String, dynamic> params = new Map();
    params['status'] = status;
    HttpManager.get(
      DsApi.consultStatus + _entity.doctorId.toString(),
      context,
      params: params,
    );
  }

  /// 点击事件
  void _headerIconAction(int type) async {
    if (type == 1) {
      // 消息
      NavigatorUtil.pushPage(context, MessageScreen());
    } else if (type == 2) {
      // 设置
      NavigatorUtil.pushPage(context, SettingScreen(), needLogin: false);
    } else if (type == 3) {
      // 客服
      EMConversation? conv =
          await EMClient.getInstance.chatManager.getConversation('13500000001');
      if (conv == null) {
        print('会话创建失败');
        return;
      }
      conv.type = EMConversationType.Chat;
      Navigator.of(context).pushNamed(
        '/chat',
        arguments: [conv.name, conv],
      ).then((value) {
        // eventBus.fire(EventBusManager.updateConversations());
      });
    } else if (type == 4) {
      // 个人信息
      NavigatorUtil.pushPage(context, MineInfoScreen());
    } else if (type == 5) {
      // 关注/粉丝
      NavigatorUtil.pushPage(context, FansScreen());
    } else if (type == 6) {
      // 会员
      if (_memberType == 1 || _memberType == 0) {
        //不是会员跳转开通会员
        NavigatorUtil.pushPage(context, OpenMemberScreen());
      } else {
        NavigatorUtil.pushPage(context, MemberLevelScreen());
      }
    } else if (type == 7) {
      // 颜值金
      NavigatorUtil.pushPage(context, IntegralScreen());
    } else if (type == 8) {
      // 会员券
      NavigatorUtil.pushPage(context, FreeScreen());
    } else if (type == 9) {
      // 优惠券
      NavigatorUtil.pushPage(context, CouponScreen());
    } else if (type == 10) {
      NavigatorUtil.pushPage(context, BeanScreen());
    }
  }

  /// 立即开卡
  void _openMemberAction() {
    NavigatorUtil.pushPage(context, OpenMemberScreen());
  }

  /// 订单
  void _orderItemAction(int type) {
    NavigatorUtil.pushPage(context, MineOrderScreen(type));
  }

  void _itemAction(int type) async {
    if (type == 1) {
      /// 官方客服
      EMConversation? conv =
          await EMClient.getInstance.chatManager.getConversation('13500000001');
      if (conv == null) {
        print('会话创建失败');
        return;
      }
      conv.type = EMConversationType.Chat;
      Navigator.of(context).pushNamed(
        '/chat',
        arguments: [conv.name, conv],
      ).then((value) {
        // eventBus.fire(EventBusManager.updateConversations());
      });
    } else if (type == 2) {
      /// 收藏
      NavigatorUtil.pushPage(context, CollectionScreen());
    } else if (type == 3) {
      /// 足迹
      NavigatorUtil.pushPage(context, FootprintScreen());
    } else if (type == 4) {
      /// 我的日记
      NavigatorUtil.pushPage(context, DiaryScreen());
    } else if (type == 5) {
      /// 签到领奖
      NavigatorUtil.pushPage(context, SignScreen());
    } else if (type == 6) {
      /// 互动回答
      NavigatorUtil.pushPage(context, QuestionScreen());
    } else if (type == 8) {
      /// 发票
      NavigatorUtil.pushPage(context, InvoiceScreen());
    } else if (type == 9) {
      /// 商家入驻
      NavigatorUtil.pushPage(context, SettleScreen());
    } else if (type == 10) {
      /// 我的咨询
      NavigatorUtil.pushPage(context, VideoOrderScreen());
    } else if (type == 11) {
      /// 咨询订单
      NavigatorUtil.pushPage(context, ConsultScreen(_entity));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: XCColors.homeDividerColor,
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
      ),
      backgroundColor: XCColors.homeDividerColor,
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: false,
        onRefresh: _init,
        header: MaterialClassicHeader(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              MineWidgets.headView(
                context,
                _memberType,
                _entity,
                _headerIconAction,
              ),
              Offstage(
                offstage: _isGrounding,
                child: MineWidgets.openMember(
                  context,
                  _memberType,
                  _openMemberAction,
                ),
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    MineWidgets.orderView(context, _orderItemAction),
                    SizedBox(height: 20),
                    MineWidgets.myView(context),
                    SizedBox(height: 10),
                    MineWidgets.menuView(
                        context, _entity.doctorId == 0, _itemAction),
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
