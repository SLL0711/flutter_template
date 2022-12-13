import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class DiaryProjectScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DiaryProjectScreenState();
}

class DiaryProjectScreenState extends State<DiaryProjectScreen>
    with AutomaticKeepAliveClientMixin {
  List<MineOrderEntity> _orderList = <MineOrderEntity>[];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestOrderInfo();
    });
  }

  /// 请求时间
  void _requestOrderInfo() async {
    // 0待支付 1待使用 2待评价 3待写日记 4已完成
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '30';
    params['status'] = '3';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.orderList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      _orderList.clear();
      List result = http.data['list'];
      if (result.isNotEmpty) {
        setState(() {
          _orderList = result.map((e) {
            return MineOrderEntity.fromJson(e);
          }).toList();
        });
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 商品item
    Widget _goodsItem(int index) {
      MineOrderEntity entity = _orderList[index];
      return Column(
        children: [
          Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Expanded(
                    child: Text('订单号：${entity.orderSn}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: XCColors.tabNormalColor))),
                Text('待写日记',
                    style: TextStyle(
                        fontSize: 14, color: XCColors.bannerSelectedColor))
              ])),
          Container(
            height: 82,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Container(
                  width: 82,
                  height: 82,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: CommonWidgets.networkImage(entity.productPic),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entity.productName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: XCColors.mainTextColor, fontSize: 14)),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Text(
                            '订单合计：',
                            style: TextStyle(
                              color: XCColors.tabNormalColor,
                              fontSize: 14,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '¥${entity.payAmount}',
                              style: TextStyle(
                                color: XCColors.themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Text(
                            'x1',
                            style: TextStyle(
                              color: XCColors.goodsGrayColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(height: 1, color: XCColors.homeDividerColor),
          Container(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: Container(
                    width: 75,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: XCColors.themeColor,
                    ),
                    child: Text(
                      '待写日记',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    /// item
    Widget _orderItem(int index) {
      MineOrderEntity entity = _orderList[index];
      return Column(children: [
        Container(height: 10, color: XCColors.homeDividerColor),
        Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  Navigator.pop(context, entity);
                },
                child: _goodsItem(index)))
      ]);
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '选择项目', () {
          Navigator.pop(context);
        }),
        body: _orderList.isEmpty
            ? EmptyWidgets.dataEmptyView(context)
            : ListView.builder(
                itemCount: _orderList.length,
                itemBuilder: (context, index) {
                  return _orderItem(index);
                }));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
