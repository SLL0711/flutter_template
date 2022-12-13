import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/info.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/withdraw.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class GoldScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GoldScreenState();
}

class GoldScreenState extends State<GoldScreen>
    with AutomaticKeepAliveClientMixin {
  GoldEntity _entity = GoldEntity();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestInfo();
    });
  }

  void _requestInfo() async {
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

  void _pushInfo() {
    Navigator.push(
            context, CupertinoPageRoute(builder: (ctx) => GoldInfoScreen()))
        .then((value) {
      if (value == null) return;
      _requestInfo();
    });
  }

  void _pushWithdraw() {
    NavigatorUtil.pushPage(context, GoldWithdrawScreen(_entity.allBalance));
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _item(String title, String value) {
      return Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(title,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: XCColors.mainTextColor)),
        SizedBox(height: 3),
        Text(value,
            style: TextStyle(fontSize: 14, color: XCColors.tabNormalColor))
      ]));
    }

    return Scaffold(
        appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.black54,
            toolbarHeight: 0,
            shadowColor: Colors.transparent),
        backgroundColor: XCColors.homeDividerColor,
        body: Stack(children: [
          Container(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                  child: Column(children: [
                Container(
                    height: 300 - MediaQuery.of(context).padding.top,
                    child: Stack(children: [
                      Container(height: 208, color: Colors.black54),
                      Positioned(
                          bottom: 0,
                          left: 15,
                          right: 15,
                          child: Container(
                              height: 118,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: Column(children: [
                                Container(
                                    height: 55,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Expanded(
                                              child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: _pushWithdraw,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('提现',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: XCColors
                                                                  .bannerSelectedColor))))),
                                          Container(
                                              width: 1,
                                              height: 14,
                                              color: XCColors.homeDividerColor),
                                          Expanded(
                                              child: GestureDetector(
                                                  behavior:
                                                      HitTestBehavior.opaque,
                                                  onTap: _pushInfo,
                                                  child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('明细',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: XCColors
                                                                  .bannerSelectedColor)))))
                                        ])),
                                Container(
                                    height: 1,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 18),
                                    color: XCColors.homeDividerColor),
                                Expanded(
                                    child: Container(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                      _item(
                                          '${_entity.withdrawBalance}', '可提现'),
                                      _item('${_entity.withdrawingBalance}',
                                          '提现中'),
                                      _item('${_entity.expenditure}', '支出')
                                    ])))
                              ]))),
                      Positioned(
                          left: 0,
                          top: MediaQuery.of(context).padding.top + 50,
                          right: 0,
                          child: Center(
                              child: Column(children: [
                            Text('${_entity.allBalance}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800)),
                            Text('累计收入',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14))
                          ])))
                    ])),
                SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Column(children: [
                      SizedBox(height: 15),
                      Text('如何获颜值金',
                          style: TextStyle(
                              fontSize: 18,
                              color: XCColors.mainTextColor,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 11),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text('目前可以通过以下两种方式获取颜值金哦：',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: XCColors.mainTextColor,
                                  fontWeight: FontWeight.bold))),
                      SizedBox(height: 8),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CommonWidgets.ruleWidget(1, '邀请好友成为会员')),
                      SizedBox(height: 5),
                      Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: CommonWidgets.ruleWidget(2, '邀请好友参加热力值活动')),
                      SizedBox(height: 12)
                    ]))
              ]))),
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                  height: kToolbarHeight,
                  child: Row(children: [
                    Container(
                        width: kToolbarHeight,
                        height: kToolbarHeight,
                        child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Image.asset("assets/images/home/back.png",
                                width: 28, height: 28, color: Colors.white),
                            tooltip: MaterialLocalizations.of(context)
                                .openAppDrawerTooltip)),
                    Expanded(
                        child: Text('颜值金',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                    Container(width: kToolbarHeight)
                  ]))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    EventCenter.defaultCenter().fire(PushTabEvent(2));
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 59,
                      alignment: Alignment.center,
                      color: XCColors.themeColor,
                      child: Text('立即赚颜值金',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)))))
        ]));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
