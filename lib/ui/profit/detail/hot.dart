import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/profit/detail/dialog.dart';
import 'package:flutter_medical_beauty/ui/profit/detail/widgets.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/invitation.dart';

import '../../../api.dart';
import '../../../colors.dart';
import '../../../http.dart';
import '../../../toast.dart';

class HotScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HotScreenState();
}

class HotScreenState extends State<HotScreen>
    with AutomaticKeepAliveClientMixin {
  // 热力值参数
  MineEntity _entity = MineEntity();
  bool _isGrounding = true;
  String _tip = '';
  String _rule = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestUserInfo();
    _requestParamsInfo();
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
  }

  void _requestParamsInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.configParams, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _tip = http.data['hotValueText'] ?? '';
        _rule = http.data['hotValueRule'] ?? '';
      });
    } else {
      ToastHud.show(context, http.message!);
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
        _entity.heatingPowerValue = _entity.heatingPowerValue - value;
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
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, 'Star积分', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
            child: Column(children: [
          SizedBox(height: 1),
          HotWidgets.hotValueView(
              context,
              int.parse(_entity.heatingPowerValue.toString().split('.').first),
              _isGrounding,
              _tip, () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => InvitationScreen()));
          }),
          SizedBox(height: 10),
          HotWidgets.hotExchangeView(context,
              int.parse(_entity.heatingPowerValue.toString().split('.').first),
              (value) {
            HotDialog.showExchangeTip(context, value, () {
              _exchangePower(value);
            });
          }),
          SizedBox(height: 10),
          HotWidgets.hotRulesView(
              context,
              int.parse(_entity.heatingPowerValue.toString().split('.').first),
              _isGrounding,
              _rule),
          SizedBox(height: 20)
        ])));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
