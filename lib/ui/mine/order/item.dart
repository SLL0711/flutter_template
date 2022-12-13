import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/pay.dart';
import 'package:flutter_medical_beauty/ui/mine/order/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';
import 'dialog.dart';

class OrderPayItem extends StatefulWidget {
  final MineOrderEntity entity;

  OrderPayItem(this.entity);

  @override
  State<StatefulWidget> createState() => _OrderPayItemState();
}

class _OrderPayItemState extends State<OrderPayItem> {
  Timer? _timer;
  int _countdownTime = 0;
  String _countText = '';

  @override
  void initState() {
    super.initState();
    int expiration = DateTime.parse(widget.entity.paymentExpirationTime)
        .millisecondsSinceEpoch;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    _countdownTime = int.parse(
        ((expiration - currentTime) / 1000).toString().split('.').first);

    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer!.cancel();
              // 刷新数据
              EventCenter.defaultCenter().fire(RefreshOrderEvent(0));
            } else {
              _countdownTime = _countdownTime - 1;
              double minutes = _countdownTime / 60;
              int seconds = _countdownTime % 60;
              _countText =
                  '剩余支付时间${minutes.toString().split('.').first}:$seconds';
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  void _cancelAction() async {
    Map<String, dynamic> params = Map();
    params['orderId'] = widget.entity.id;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.cancelOrder, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '取消成功');
      EventCenter.defaultCenter().fire(RefreshOrderEvent(0));
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigatorUtil.pushPage(context, OrderDetailScreen(widget.entity.id));
      },
      splashColor: Colors.grey,
      child: Column(
        children: [
          Container(
            height: 45,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '订单号：${widget.entity.orderSn}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                  ),
                ),
                Text(
                  '待付款',
                  style: TextStyle(
                      fontSize: 14, color: XCColors.bannerSelectedColor),
                ),
              ],
            ),
          ),
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
                  child: CommonWidgets.networkImage(widget.entity.productPic),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.entity.productName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 14),
                      ),
                      Expanded(child: Container()),
                      Row(
                        children: [
                          Text(
                              '${widget.entity.isAllPay == 1 ? '需支付：' : '预约金：'}',
                              style: TextStyle(
                                  color: XCColors.tabNormalColor,
                                  fontSize: 14)),
                          Expanded(
                            child: Text(
                              '¥${widget.entity.isAllPay == 1 ? widget.entity.allPayAmount : widget.entity.payAmount}',
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
              children: [
                Expanded(
                    child: Text(_countText,
                        style: TextStyle(
                            color: XCColors.tabNormalColor, fontSize: 12))),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    OrderDialog.showCancelDialog(context, _cancelAction);
                  },
                  child: Container(
                    width: 75,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        border: Border.all(
                            width: 1, color: XCColors.mineHeaderDividerColor)),
                    child: Text(
                      '取消订单',
                      style: TextStyle(
                          color: XCColors.tabNormalColor, fontSize: 14),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.entity.productName.isEmpty)
                      return ToastHud.show(context, '订单异常');
                    NavigatorUtil.pushPage(
                      context,
                      OrderPayScreen(widget.entity.id),
                    );
                  },
                  child: Container(
                    width: 75,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      color: XCColors.themeColor,
                    ),
                    child: Text(
                      '去支付',
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
      ),
    );
  }
}
