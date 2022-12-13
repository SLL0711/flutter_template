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
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/bean/bill.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/info.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/withdraw.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class BeanGoodsScreen extends StatefulWidget {
  final int type;

  BeanGoodsScreen(this.type);

  @override
  State<StatefulWidget> createState() => BeanGoodsScreenState();
}

class BeanGoodsScreenState extends State<BeanGoodsScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _goodsItem() {
      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      double imageWidth = (screenWidth - 40) * 0.5;
      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(children: [
            Container(
                width: imageWidth,
                height: imageWidth,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    border:
                        Border.all(color: XCColors.homeDividerColor, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(6)))),
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
                      fontSize: 10, color: XCColors.bannerSelectedColor)),
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
          ]));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(
            context,
            widget.type == 0
                ? '黄金会员专区'
                : widget.type == 1
                    ? '铂金会员专区'
                    : '钻石会员专区', () {
          Navigator.pop(context);
        }),
        body: StaggeredGridView.countBuilder(
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
            crossAxisCount: 4,
            itemCount: 8,
            itemBuilder: (BuildContext context, int index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NavigatorUtil.pushPage(context, DetailScreen(1, isBean: true),
                      needLogin: false);
                },
                child: _goodsItem()),
            staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
