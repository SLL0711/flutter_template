import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/store/settle.dart';
import 'package:flutter_medical_beauty/ui/mine/store/success.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:tobias/tobias.dart' as tobias;

import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';
import 'entity.dart';

class StorePayScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StorePayScreenState();
}

class StorePayScreenState extends State<StorePayScreen>
    with AutomaticKeepAliveClientMixin {
  // 支付方式
  int _payType = 1;

  // 入驻信息
  ApplyInfoEntity _applyInfo = ApplyInfoEntity();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _init();
    });

    // 微信支付回调
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        print("pay :${res.isSuccessful}");
        if (res.isSuccessful) {
          ToastHud.show(context, "支付成功");
          _paySuccess();
        } else {
          ToastHud.show(context, "开通失败");
        }
      }
    });

    super.initState();
  }

  Future<void> _init() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.applyInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data is Map<String, dynamic>) {
        setState(() {
          _applyInfo = ApplyInfoEntity.fromJson(http.data);
          // 根据状态跳转界面
          if (_applyInfo.auditStatus != 1) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (builder) => SettleScreen(),
              ),
            );
          }
        });
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _payAction() async {
    if (_payType == 1) {
      //检测是否安装微信
      bool isInstalled = await fluwx.isWeChatInstalled;
      if (isInstalled) {
        _requestPayConfig();
      } else {
        ToastHud.show(context, '请先安装微信');
      }
    } else if (_payType == 4) {
      //检测是否安装支付宝
      var result = await tobias.isAliPayInstalled();
      if (result) {
        _requestPayConfig();
      } else {
        ToastHud.show(context, "请先安装支付宝");
      }
    }
  }

  void _requestPayConfig() async {
    //去支付
    Map<String, dynamic> params = Map();
    //支付类型 1微信app支付 2微信小程序支付 3微信H5支付 4支付宝支付 5花呗分期
    params['payType'] = _payType;
    // 支付来源 0订单支付 1尾款支付 2购买会员 3提现 4入驻
    params['source'] = '4';
    params['sourceId'] = _applyInfo.id;
    params['totalAmount'] =
        _applyInfo.merchantPayAmount + _applyInfo.merchantGuaranteeAmount;
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.pay, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      PayEntity payEntity = PayEntity.fromJson(http.data);
      if (_payType == 1) {
        _wechatPay(payEntity);
      } else if (_payType == 4) {
        _alipay(payEntity);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _paySuccess() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (builder) => StoreSuccessScreen(),
      ),
    );
  }

  void _alipay(PayEntity payEntity) async {
    //orderInfo为后台返回的orderInfo
    var payResult = await tobias.aliPay(payEntity.aliPayRequest);
    if (payResult['result'] != null) {
      if (payResult['resultStatus'] == '9000') {
        ToastHud.show(context, "支付宝支付成功");
        _paySuccess();
      } else {
        ToastHud.show(context, "支付宝支付失败");
      }
    }
  }

  void _wechatPay(PayEntity payEntity) async {
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _amountInfoWidget(String title, String amount,
        {bool isTotal = false}) {
      return Column(children: [
        Container(
            width: double.infinity,
            height: 50,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 16,
                          color: XCColors.mainTextColor,
                          fontWeight:
                              isTotal ? FontWeight.bold : FontWeight.normal)),
                  Text(amount,
                      style: isTotal
                          ? TextStyle(
                              fontSize: 16,
                              color: XCColors.mainTextColor,
                              fontWeight: FontWeight.bold)
                          : TextStyle(
                              fontSize: 16, color: XCColors.tabNormalColor))
                ])),
        Container(height: 1, color: XCColors.homeDividerColor)
      ]);
    }

    Widget _payItemWidget(String title, String image, int type) {
      return Column(
        children: [
          Container(
              height: 65,
              child: Row(children: [
                SizedBox(width: 2),
                Container(
                    width: 18,
                    height: 18,
                    child: Image.asset(image, fit: BoxFit.cover)),
                SizedBox(width: 15),
                Expanded(
                    child: Text(title,
                        style: TextStyle(
                            fontSize: 16, color: XCColors.mainTextColor))),
                SizedBox(width: 10),
                Container(
                    width: 20,
                    height: 20,
                    child: Image.asset(
                        type == _payType
                            ? 'assets/images/box/box_check_selected.png'
                            : 'assets/images/box/box_check_normal.png',
                        fit: BoxFit.cover))
              ])),
          Container(
              padding: const EdgeInsets.only(left: 35),
              height: 1,
              color: XCColors.homeDividerColor)
        ],
      );
    }

    Widget _bodyWidget() {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(height: 1, color: XCColors.homeDividerColor),
              _amountInfoWidget('认证费用：', '${_applyInfo.merchantPayAmount}元'),
              _amountInfoWidget(
                  '保证金费用：', '${_applyInfo.merchantGuaranteeAmount}元'),
              _amountInfoWidget('合计：',
                  '${_applyInfo.merchantPayAmount + _applyInfo.merchantGuaranteeAmount}元',
                  isTotal: true),
              SizedBox(height: 32),
              Row(children: [
                Container(
                    width: 2, height: 18, color: XCColors.bannerSelectedColor),
                SizedBox(width: 7),
                Text('支付方式',
                    style: TextStyle(
                        fontSize: 18,
                        color: XCColors.mainTextColor,
                        fontWeight: FontWeight.bold))
              ]),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _payType = 1;
                  });
                },
                child: _payItemWidget(
                    '微信支付', 'assets/images/mine/mine_store_pay_wechat.png', 1),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    _payType = 4;
                  });
                },
                child: _payItemWidget(
                    '支付宝', 'assets/images/mine/mine_store_pay_alipay.png', 4),
              ),
              /*_payItemWidget(
                    '银行卡', 'assets/images/mine/mine_store_pay_alipay.png'),*/
              SizedBox(height: 55),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _payAction,
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.themeColor,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
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
        appBar: CityWidgets.cityAppBar(context, '支付认证费用', () {
          Navigator.pop(context);
        }),
        body: _bodyWidget());
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
