import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/bill.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/goods.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/rule.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/info.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/withdraw.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class BeanScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BeanScreenState();
}

class BeanScreenState extends State<BeanScreen>
    with AutomaticKeepAliveClientMixin {
  void _pushDetailAction() {
    NavigatorUtil.pushPage(context, BeanBillScreen());
  }

  void _pushMoreAction(int type) {
    NavigatorUtil.pushPage(context, BeanGoodsScreen(type));
  }

  void _pushRuleView() {
    NavigatorUtil.pushPage(context, BeanRuleScreen());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _goodsItem() {
      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      double imageWidth = (screenWidth - 90) * 0.5;
      return Expanded(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                NavigatorUtil.pushPage(context, DetailScreen(1, isBean: true, isBeanGoods: true),
                    needLogin: false);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    Container(
                        width: imageWidth,
                        height: imageWidth,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: XCColors.homeDividerColor, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(6)))),
                    SizedBox(height: 10),
                    Text('时尚变幻，哑光风潮永不过时，哑光唇膏…',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 3),
                    Row(children: [
                      Text('10000豆',
                          style: TextStyle(
                              fontSize: 10,
                              color: XCColors.bannerSelectedColor)),
                      SizedBox(width: 3),
                      Expanded(
                          child: Text('¥288',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: XCColors.tabNormalColor,
                                  fontSize: 10,
                                  color: XCColors.tabNormalColor)))
                    ]),
                    SizedBox(height: 18)
                  ]))));
    }

    Widget _item(String title, int type) {
      return Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _pushMoreAction(type);
                },
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    height: 40,
                    child: Row(children: [
                      Expanded(
                          child: Text(title,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: XCColors.mainTextColor,
                                  fontWeight: FontWeight.bold))),
                      Text('更多',
                          style: TextStyle(
                              fontSize: 12, color: XCColors.tabNormalColor)),
                      SizedBox(width: 5),
                      CommonWidgets.grayRightArrow()
                    ]))),
            Row(
                children: List.generate(2, (index) {
              return _goodsItem();
            })),
            Container(height: 10, color: XCColors.homeDividerColor)
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
          Container(width: double.infinity, height: double.infinity),
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Container(
                  height: 208,
                  color: Colors.black54,
                  child: Column(children: [
                    SizedBox(height: 105),
                    Text('100',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800)),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _pushRuleView,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('颜值豆',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14)),
                              SizedBox(width: 5),
                              Container(
                                  width: 14,
                                  height: 14,
                                  child: Image.asset(
                                      'assets/images/home/home_detail_tip.png',
                                      fit: BoxFit.cover))
                            ]))
                  ]))),
          Positioned(
              top: 180,
              left: 0,
              right: 0,
              bottom: 80,
              child: SingleChildScrollView(
                  child: Column(
                      children: List.generate(3, (index) {
                return _item(
                    index == 0
                        ? '黄金会员专区'
                        : index == 1
                            ? '铂金会员专区'
                            : '钻石会员专区',
                    index);
              })))),
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
                        child: Text('颜值豆',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _pushDetailAction,
                        child: Container(
                            width: kToolbarHeight,
                            height: kToolbarHeight,
                            alignment: Alignment.center,
                            child: Text('明细',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white))))
                  ]))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    EventCenter.defaultCenter().fire(PushTabEvent(0));
                    Navigator.pop(context);
                  },
                  child: Container(
                      height: 69,
                      alignment: Alignment.center,
                      color: XCColors.themeColor,
                      child: Text('获取更多颜值豆',
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
