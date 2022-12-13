import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/pay.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/widgets.dart';

import '../../../tool.dart';

class OrderDetailScreen extends StatefulWidget {
  final int orderId;

  OrderDetailScreen(this.orderId);

  @override
  State<StatefulWidget> createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen>
    with AutomaticKeepAliveClientMixin {
  // 订单详情参数
  MineOrderEntity _order = MineOrderEntity();
  Timer? _timer;
  int _countdownTime = 0;
  String _countText = '';
  List<ProductItemEntity> _productList = <ProductItemEntity>[];
  bool _isGrounding = false;

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestOrderInfo();
    _requestGuess();
  }

  void _countdown() {
    int expiration =
        DateTime.parse(_order.paymentExpirationTime).millisecondsSinceEpoch;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    _countdownTime = int.parse(
        ((expiration - currentTime) / 1000).toString().split('.').first);

    const oneSec = const Duration(seconds: 1);

    var callback = (timer) => {
          setState(() {
            if (_countdownTime < 1) {
              _timer!.cancel();
              // 刷新数据
              ToastHud.show(context, '支付时间已结束');
              EventCenter.defaultCenter().fire(RefreshOrderEvent(0));
              Navigator.pop(context);
            } else {
              _countdownTime = _countdownTime - 1;
              double minutes = _countdownTime / 60;
              int seconds = _countdownTime % 60;
              _countText = '${minutes.toString().split('.').first}:$seconds';
            }
          })
        };
    _timer = Timer.periodic(oneSec, callback);
  }

  void _requestGuess() async {
    ToastHud.loading(context);
    Map<String, dynamic> params = Map();
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    params['provinceCode'] = await Tool.getString('provinceCode');
    params['cityCode'] = await Tool.getString('cityCode');
    params['latitude'] = await Tool.getString('latitude');
    params['longitude'] = await Tool.getString('longitude');
    var http =
        await HttpManager.get(DsApi.guessYouLike, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _productList = ProductEntity.fromJson(http.data).list;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 请求时间
  void _requestOrderInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.orderDetail + widget.orderId.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _order = MineOrderEntity.fromJson(http.data);
        _countdown();
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _cancelAction() async {
    Map<String, dynamic> params = Map();
    params['orderId'] = widget.orderId;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.cancelOrder, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '取消成功');
      EventCenter.defaultCenter().fire(RefreshOrderEvent(0));
      Navigator.pop(context);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _bottomTool() {
      return Container(
        height: 80,
        child: Column(
          children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            Container(
              color: Colors.white,
              height: 30,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '剩余支付时间',
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    _countText,
                    style: TextStyle(
                      color: XCColors.detailSelectedColor,
                      fontSize: 12,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        OrderDialog.showCancelDialog(context, _cancelAction);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: XCColors.mineOrderButtonColor,
                        child: Text(
                          '取消订单',
                          style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_order.productName.isEmpty)
                          return ToastHud.show(context, '订单异常');
                        NavigatorUtil.pushPage(
                          context,
                          OrderPayScreen(widget.orderId),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: XCColors.themeColor,
                        child: Text(
                          '去支付',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '订单详情', () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          _productList.isEmpty
              ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    MineOrderWidgets.orderDetailHeaderWidget(
                      context,
                      _order,
                      _isGrounding,
                    ),
                    Container(height: 20, color: XCColors.homeDividerColor)
                  ])))
              : NestedScrollView(
                  body: _productList.isEmpty
                      ? Container()
                      : OrderWidgets.orderBodyWidget(
                          context,
                          _productList,
                          hasBottom: true,
                        ),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            MineOrderWidgets.orderDetailHeaderWidget(
                              context,
                              _order,
                              _isGrounding,
                            ),
                            Container(
                                height: 20, color: XCColors.homeDividerColor),
                            OrderWidgets.payTipWidget(context)
                          ],
                        ),
                      ),
                    ];
                  },
                ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _bottomTool(),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
