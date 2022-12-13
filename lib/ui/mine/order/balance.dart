import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/pay.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class MineOrderFinalScreen extends StatefulWidget {
  final MineOrderEntity entity;

  MineOrderFinalScreen(this.entity);

  @override
  State<StatefulWidget> createState() => MineOrderFinalScreenState();
}

class MineOrderFinalScreenState extends State<MineOrderFinalScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isCoupon1 = false;
  bool _isCoupon2 = false;
  bool _isCoupon3 = false;

  MineOrderFinalEntity _finalEntity = MineOrderFinalEntity();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestOrderInfo();
    });
  }

  /// 请求时间
  void _requestOrderInfo() async {
    Map<String, dynamic> params = Map();
    params['isBeautyGold'] = '0';
    params['isCoupon'] = '0';
    params['memberCouponId'] = '0';

    ToastHud.loading(context);
    var http = await HttpManager.post(
        DsApi.finalPaymentShow + widget.entity.id.toString(), params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _finalEntity = MineOrderFinalEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _payAction() async {
    Map<String, dynamic> params = Map();
    params['isBeautyGold'] = _isCoupon2 ? '1' : '0';
    params['isCoupon'] = _isCoupon1 ? '1' : '0';
    params['memberCouponId'] = _isCoupon3 ? '1' : '0';

    ToastHud.loading(context);
    var http = await HttpManager.post(
        DsApi.finalPayment + widget.entity.id.toString(), params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      DetailOrderPayEntity entity = DetailOrderPayEntity.fromJson(http.data);
      if (entity.isPay == 1) {
        NavigatorUtil.pushPage(
            context,
            OrderPayScreen(
              entity.orderId,
              source: 1,
            ));
      } else {
        ToastHud.show(context, '支付成功');
        Navigator.pop(context);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _onTapAction(int type) {
    setState(() {
      if (type == 1) {
        _isCoupon1 = !_isCoupon1;
      } else if (type == 2) {
        _isCoupon2 = !_isCoupon2;
      } else if (type == 3) {
        _isCoupon3 = !_isCoupon3;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 商品item
    Widget _goodsInfo() {
      return Container(
          color: Colors.white,
          height: 100,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(children: [
            Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: CommonWidgets.networkImage(widget.entity.productPic)),
            SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.entity.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14)),
                  Expanded(child: Container()),
                  Row(children: [
                    Text('预约金：',
                        style: TextStyle(
                            color: XCColors.tabNormalColor, fontSize: 14)),
                    Expanded(
                        child: Text('¥${widget.entity.payAmount}',
                            style: TextStyle(
                                color: XCColors.bannerSelectedColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    Text('x1',
                        style: TextStyle(
                            color: XCColors.goodsGrayColor, fontSize: 14))
                  ])
                ]))
          ]));
    }

    Widget _bodyWidget() {
      return SingleChildScrollView(
          child: Column(children: [
        SizedBox(height: 10),
        _goodsInfo(),
        SizedBox(height: 10),
        Container(
            height: 50,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(children: [
              Expanded(
                  child: Text('应付尾款',
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14))),
              Text('¥${_finalEntity.finalPrice}',
                  style:
                      TextStyle(color: XCColors.tabNormalColor, fontSize: 14))
            ])),
        SizedBox(height: 10),
        Container(
            height: 285,
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: 10),
              Text('优惠折扣',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: XCColors.mainTextColor,
                      fontSize: 16)),
              SizedBox(height: 5),
              Offstage(
                  offstage: _finalEntity.isHaveBeautyGold != 1,
                  child: Container(
                      height: 54,
                      child: Row(children: [
                        Expanded(
                            child: Text(
                                _finalEntity.minPoint == 0
                                    ? '${_finalEntity.couponAmount}优惠券'
                                    : '满${_finalEntity.minPoint}-${_finalEntity.couponAmount}优惠券',
                                style: TextStyle(
                                    color: XCColors.mainTextColor,
                                    fontSize: 14))),
                        SizedBox(width: 10),
                        Text('-${_finalEntity.couponAmount}',
                            style: TextStyle(
                                color: XCColors.bannerSelectedColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _onTapAction(1);
                            },
                            child: Image.asset(
                                _isCoupon1
                                    ? 'assets/images/home/home_detail_order_insurance_on.png'
                                    : 'assets/images/home/home_detail_order_insurance_off.png',
                                height: 20,
                                width: 40))
                      ]))),
              Offstage(
                  offstage: _finalEntity.isHaveCoupon != 1,
                  child: Container(
                      height: 54,
                      child: Row(children: [
                        Expanded(
                            child: Text('可用${_finalEntity.beautyBalance}元颜值金抵用',
                                style: TextStyle(
                                    color: XCColors.mainTextColor,
                                    fontSize: 14))),
                        SizedBox(width: 10),
                        Text('-${_finalEntity.beautyBalance}',
                            style: TextStyle(
                                color: XCColors.bannerSelectedColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _onTapAction(2);
                            },
                            child: Image.asset(
                                _isCoupon2
                                    ? 'assets/images/home/home_detail_order_insurance_on.png'
                                    : 'assets/images/home/home_detail_order_insurance_off.png',
                                height: 20,
                                width: 40))
                      ]))),
              Container(
                  height: 54,
                  child: Row(children: [
                    Expanded(
                        child: Text('自购返减${_finalEntity.vipAmount}元',
                            style: TextStyle(
                                color: XCColors.mainTextColor, fontSize: 14))),
                    SizedBox(width: 10),
                    Text('-${_finalEntity.vipAmount}',
                        style: TextStyle(
                            color: XCColors.bannerSelectedColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 5),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _onTapAction(3);
                        },
                        child: Image.asset(
                            _isCoupon3
                                ? 'assets/images/home/home_detail_order_insurance_on.png'
                                : 'assets/images/home/home_detail_order_insurance_off.png',
                            height: 20,
                            width: 40))
                  ]))
            ]))
      ]));
    }

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '尾款支付', () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          Container(height: double.infinity, child: _bodyWidget()),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 15),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                      child: RichText(
                          text: TextSpan(
                              text: '剩余应付尾款：',
                              style: TextStyle(
                                  color: XCColors.mainTextColor, fontSize: 12),
                              children: [
                        TextSpan(
                            text: '¥',
                            style: TextStyle(
                                color: XCColors.bannerSelectedColor,
                                fontSize: 14)),
                        TextSpan(
                            text: '${_finalEntity.finalPayAmount}',
                            style: TextStyle(
                                color: XCColors.bannerSelectedColor,
                                fontSize: 18))
                      ]))),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _payAction,
                    child: Container(
                      width: 120,
                      height: 50,
                      alignment: Alignment.center,
                      color: XCColors.themeColor,
                      child: Text(
                        '立即支付',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
