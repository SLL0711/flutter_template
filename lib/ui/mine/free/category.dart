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
import 'package:flutter_medical_beauty/ui/mine/free/dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FreeCategoryScreen extends StatefulWidget {
  final int type;

  FreeCategoryScreen(this.type);

  @override
  State<StatefulWidget> createState() => FreeCategoryScreenState();
}

class FreeCategoryScreenState extends State<FreeCategoryScreen>
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
    params['isFree'] = '1';
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
          height: 180,
          margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(widget.type == 0
                ? 'assets/images/mine/mine_coupon_free.png'
                : 'assets/images/mine/mine_coupon_free_gray.png'),
            fit: BoxFit.cover,
          )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(children: [
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Text(entity.couponName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              SizedBox(height: 14),
                              Text(entity.note,
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ])),
                        SizedBox(width: 10),
                        Container(width: 1, height: 75, color: Colors.white),
                        Container(
                            width: 110,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        FreeDialog.showRuleDialog(context, () {
                                          EventCenter.defaultCenter()
                                              .fire(PushTabEvent(0));
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text('使用规则',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                SizedBox(width: 5),
                                                Container(
                                                    width: 7,
                                                    height: 14,
                                                    child: Image.asset(
                                                        'assets/images/mine/mine_white_arrow_right.png',
                                                        fit: BoxFit.cover))
                                              ]))),
                                  SizedBox(height: widget.type == 0 ? 20 : 5),
                                  widget.type == 0
                                      ? GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          onTap: () {
                                            EventCenter.defaultCenter()
                                                .fire(PushTabEvent(0));
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                              width: 62,
                                              height: 26,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(13)),
                                                  color: XCColors
                                                      .couponButtonColor),
                                              child: Text('使用',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white))))
                                      : Image.asset(
                                          widget.type == 1
                                              ? 'assets/images/mine/mine_coupon_free_complete.png'
                                              : 'assets/images/mine/mine_coupon_free_overdue.png',
                                          width: 64,
                                          height: 64),
                                ]))
                      ]))),
              Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text('有效期：${entity.startTime}至${entity.endTime}',
                      style: TextStyle(
                          fontSize: 12, color: XCColors.mainTextColor)))
            ],
          ));
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
                return _item(index);
              },
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
