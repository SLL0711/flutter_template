import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/bill.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/info.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/withdraw.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BeanRuleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BeanRuleScreenState();
}

class BeanRuleScreenState extends State<BeanRuleScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _contentView(String title, String value) {
      return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                  width: 2, height: 12, color: XCColors.bannerSelectedColor),
              SizedBox(width: 4),
              Text(title,
                  style: TextStyle(fontSize: 14, color: XCColors.mainTextColor))
            ]),
            SizedBox(height: 5),
            Container(
                padding: const EdgeInsets.only(left: 6),
                child: Text(value,
                    style: TextStyle(
                        height: 1.6,
                        fontSize: 12,
                        color: XCColors.tabNormalColor)))
          ]));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '如何获取聚美豆', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15, top: 18, bottom: 18),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          width: 1, color: XCColors.homeDividerColor))),
              child: Row(children: [
                Container(height: 16, width: 16, color: Colors.red),
                SizedBox(width: 5),
                Text('1元=10个聚美豆',
                    style: TextStyle(
                        fontSize: 16,
                        color: XCColors.mainTextColor,
                        fontWeight: FontWeight.bold))
              ])),
          _contentView('1.新用户注册：', '（必须绑定手机号)可一次性获得5个豆；'),
              _contentView('2.购买获豆：', '（1）购买聚美会员可一次性获得10个豆；\n（2）购买项目；按照项目价格10:1赠送(消费后生效)；'),
              _contentView('3.体验产品：', '体验产品完成，写评价可获得20个豆；（限每月一单）'),
              _contentView('4.写体验日记：', '可获得35个豆；（三日后生效得豆，限每日一单)'),
              _contentView('5.分享获豆：', '（1）分享软文至社交平台可获得10个豆\n（2）分享会员权利至社交平台可获得5个豆\n（3）晒单至社交平台可获得10个豆；\n（以上为每天首单获豆数量，第二单获1个豆，第三单起不获豆）'),
              _contentView('6.邀请好友注册小程序获豆：', '邀请1--20人，每邀请1人得10个豆；邀请21—50人 ，每邀请1人得8个豆，邀请50人以上，每邀请1人得6个豆。'),
              _contentView('7.签到积分：', '首日可领1个豆，连续签到每日可递增1个豆，连续签到每日可领取积分上限为7个豆。若签到中断则重新计算。每天只有一次签到领聚美豆机会。'),
              _contentView('8.关注获豆：', '雀斑公众号/小红书/微博/抖音官方账号各得5个豆\n(截图给客服）\n如还有其他问题请咨询客服'),
        ])));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
