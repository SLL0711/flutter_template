import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/coupon/entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CouponCategoryScreen extends StatefulWidget {
  final int type;

  CouponCategoryScreen(this.type);

  @override
  State<StatefulWidget> createState() => CouponCategoryScreenState();
}

class CouponCategoryScreenState extends State<CouponCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<CouponEntity> _itemList = <CouponEntity>[];

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestInfo();
    });
  }

  void _requestInfo() async {
    Map<String, String> params = Map();
    params['isFree'] = '0';
    params['useStatus'] = widget.type.toString();

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.couponList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      _itemList.clear();

      setState(() {
        http.data.forEach((element) {
          _itemList.add(CouponEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _item(int index) {
      CouponEntity entity = _itemList[index];
      return Container(
        height: 120,
        margin: const EdgeInsets.only(top: 20, left: 15, right: 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(color: XCColors.bannerShadowColor, blurRadius: 10)
            ]),
        child: Row(
          children: [
            Container(
              width: 105,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: '¥',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: XCColors.bannerSelectedColor),
                      children: [
                        TextSpan(
                          text: entity.amount.toString().split('.').first,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: XCColors.bannerSelectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    entity.minPoint == 0
                        ? ''
                        : '满${entity.minPoint.toString().split('.').first}减${entity.amount.toString().split('.').first}',
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.goodsGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(entity.couponName,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: XCColors.mainTextColor)),
                  SizedBox(height: 10),
                  Text(
                    entity.note,
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.goodsGrayColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${entity.endTime}到期',
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.goodsGrayColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            widget.type == 0
                ? GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      EventCenter.defaultCenter().fire(PushTabEvent(0));
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 60,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(11)),
                          color: XCColors.bannerSelectedColor),
                      child: Text(
                        '立即使用',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                : Image.asset(
                    widget.type == 1
                        ? 'assets/images/mine/mine_coupon_complete.png'
                        : 'assets/images/mine/mine_coupon_overdue.png',
                    width: 72,
                    height: 72,
                  ),
            SizedBox(width: 12)
          ],
        ),
      );
    }

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: false,
      onRefresh: _requestInfo,
      header: MaterialClassicHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          return HomeWidgets.homeRefresherFooter(context, mode);
        },
      ),
      child: _itemList.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : ListView.builder(
              itemCount: _itemList.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    _item(index),
                    Positioned(
                      top: 20,
                      right: 15,
                      child: Offstage(
                        offstage: true,
                        child: Image.asset(
                          'assets/images/mine/mine_coupon_will_overdue.png',
                          width: 60,
                          height: 30,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
