import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/result.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;

class VideoPayScreen extends StatefulWidget {
  final int orderId, source;

  VideoPayScreen(this.orderId, {this.source = 0});

  @override
  State<StatefulWidget> createState() => VideoPayScreenState();
}

class VideoPayScreenState extends State<VideoPayScreen>
    with AutomaticKeepAliveClientMixin {
  // 支付相关参数
  Timer? _timer;
  int _countdownTime = 1800;
  String _countText = '';
  int _payType = 1;
  int _stages = 12;

  // 订单信息
  MineOrderEntity _order = MineOrderEntity();

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 微信支付回调
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        print("pay :${res.isSuccessful}");
        int type = res.isSuccessful ? 1 : 2;
        _payResult(type);
      }
    });

    Future.delayed(Duration.zero, _requestOrder);
  }

  void _countdown() {
    int expiration =
        DateTime.parse(_order.paymentExpirationTime).millisecondsSinceEpoch;
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    _countdownTime = int.parse(
        ((expiration - currentTime) / 1000).toString().split('.').first);

    const oneSec = const Duration(seconds: 1);
    if (_timer != null) _timer!.cancel();
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (_countdownTime < 1) {
          // 支付失败
        } else {
          _countdownTime = _countdownTime - 1;
          double minutes = _countdownTime / 60;
          int seconds = _countdownTime % 60;
          _countText = '支付剩余时间 ${minutes.toString().split('.').first}:$seconds';
        }
      });
    });
  }

  void _requestOrder() async {
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.orderDetail + '${widget.orderId}', context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _order = MineOrderEntity.fromJson(http.data);
        _countdown();
      });
    } else {
      ToastHud.show(context, http.message!);
      Navigator.of(context).pop();
    }
  }

  void _payAction() {
    if (_payType == 1) {
      _wechatPay();
    } else if (_payType == 2) {
      _alipay('4');
    } else if (_payType == 3) {
      _alipay('5');
    }
  }

  void _alipay(String payType) async {
    //检测是否安装支付宝
    var result = await tobias.isAliPayInstalled();
    if (result) {
      //去支付
      Map<String, dynamic> params = Map();
      //支付类型 1微信app支付 2微信小程序支付 3微信H5支付 4支付宝支付 5花呗分期
      params['payType'] = payType;
      // 支付来源 0订单支付 1尾款支付 2购买会员 3提现 4入驻
      if (_payType == 3) {
        // 花呗分期数
        params['hbFqNum'] = _stages;
      }
      params['source'] = widget.source;
      params['sourceId'] = _order.id;
      params['totalAmount'] = _order.isAllPay == 1
          ? _order.allPayAmount.toString()
          : widget.source == 1
              ? _order.finalPayAmount.toString()
              : _order.payAmount.toString();
      ToastHud.loading(context);
      var http = await HttpManager.post(DsApi.pay, params, context);
      ToastHud.dismiss();
      if (http.code == 200) {
        PayEntity payEntity = PayEntity.fromJson(http.data);
        //orderInfo为后台返回的orderInfo
        var payResult = await tobias.aliPay(payEntity.aliPayRequest);
        if (payResult['result'] != null) {
          if (payResult['resultStatus'] == '9000') {
            ToastHud.show(context, "支付宝支付成功");
            _payResult(1);
          } else {
            ToastHud.show(context, payResult['memo'] ?? "支付宝支付失败");
            _payResult(2);
          }
        }
      } else {
        ToastHud.show(context, http.message!);
      }
    } else {
      ToastHud.show(context, "请先安装支付宝");
    }
  }

  void _wechatPay() async {
    bool isInstalled = await fluwx.isWeChatInstalled;
    if (!isInstalled) {
      ToastHud.show(context, '请先安装微信');
      return;
    }
    //
    Map<String, dynamic> params = Map();
    params['payType'] = '1';
    //支付来源 0订单支付 1尾款支付 2购买会员 3提现 4入驻
    params['source'] = widget.source;
    params['sourceId'] = _order.id.toString();
    params['totalAmount'] = _order.isAllPay == 1
        ? _order.allPayAmount.toString()
        : widget.source == 1
            ? _order.finalPayAmount.toString()
            : _order.payAmount.toString();
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.pay, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      PayEntity payEntity = PayEntity.fromJson(http.data);
      fluwx
          .payWithWeChat(
              appId: payEntity.wxPayRequest.appId,
              partnerId: payEntity.wxPayRequest.partnerId,
              prepayId: payEntity.wxPayRequest.prepayId,
              packageValue: payEntity.wxPayRequest.packageValue,
              nonceStr: payEntity.wxPayRequest.nonceStr,
              timeStamp: int.parse(payEntity.wxPayRequest.timeStamp),
              sign: 'sign')
          .then((value) {
        print("---》$value");
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _payResult(int type) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (builder) => OrderPayResultScreen(type, widget.orderId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _payItemWidget(
        String title, String image, int payType, String selectedImage) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            _payType = payType;
          });
        },
        child: Container(
          height: 65,
          child: Row(
            children: [
              SizedBox(width: 2),
              Container(
                width: 18,
                height: 18,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Container(
                  height: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: XCColors.homeDividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          color: XCColors.mainTextColor,
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          selectedImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // 分期组件
    Widget _stagesWidget() {
      return Container(
        padding: EdgeInsets.only(left: 30, top: 15),
        width: double.infinity,
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _stages = 3;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    child: Image.asset(_stages == 3
                        ? 'assets/images/box/box_check_selected.png'
                        : 'assets/images/box/box_check_normal.png'),
                  ),
                  SizedBox(width: 5),
                  Text("3期"),
                ],
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _stages = 6;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    child: Image.asset(_stages == 6
                        ? 'assets/images/box/box_check_selected.png'
                        : 'assets/images/box/box_check_normal.png'),
                  ),
                  SizedBox(width: 5),
                  Text("6期"),
                ],
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  _stages = 12;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    child: Image.asset(_stages == 12
                        ? 'assets/images/box/box_check_selected.png'
                        : 'assets/images/box/box_check_normal.png'),
                  ),
                  SizedBox(width: 5),
                  Text("12期"),
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _bodyWidget() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(height: 1, color: XCColors.homeDividerColor),
              SizedBox(height: 40),
              Text(_countText,
                  style:
                      TextStyle(fontSize: 14, color: XCColors.tabNormalColor)),
              RichText(
                text: TextSpan(
                  text: '¥',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: XCColors.mainTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: _order.isAllPay == 1
                          ? _order.allPayAmount.toString()
                          : widget.source == 1
                              ? _order.finalPayAmount.toString()
                              : _order.payAmount.toString(),
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Container(
                  width: double.infinity,
                  child: Text('选择支付方式：',
                      style: TextStyle(
                          fontSize: 18, color: XCColors.mainTextColor))),
              _payItemWidget(
                  '微信支付',
                  'assets/images/mine/mine_store_pay_wechat.png',
                  1,
                  _payType == 1
                      ? 'assets/images/box/box_check_selected.png'
                      : 'assets/images/box/box_check_normal.png'),
              _payItemWidget(
                  '支付宝',
                  'assets/images/mine/mine_store_pay_alipay.png',
                  2,
                  _payType == 2
                      ? 'assets/images/box/box_check_selected.png'
                      : 'assets/images/box/box_check_normal.png'),
              _payItemWidget(
                  '花呗分期',
                  'assets/images/home/home_flowers.png',
                  3,
                  _payType == 3
                      ? 'assets/images/box/box_check_selected.png'
                      : 'assets/images/box/box_check_normal.png'),
              Stack(
                children: [
                  SizedBox(height: 200),
                  Positioned(
                    child: _payType == 3 ? _stagesWidget() : SizedBox(),
                  ),
                ],
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _payAction,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.themeColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Text(
                    '立即支付',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '支付订单', () {
          Navigator.pop(context);
        }),
        body: _bodyWidget());
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
