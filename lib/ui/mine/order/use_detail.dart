import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/create.dart';
import 'package:flutter_medical_beauty/ui/mine/order/balance.dart';
import 'package:flutter_medical_beauty/ui/mine/order/comment.dart';
import 'package:flutter_medical_beauty/ui/mine/order/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/refund.dart';
import 'package:flutter_medical_beauty/ui/mine/order/widgets.dart';
import 'package:flutter_medical_beauty/ui/profit/poster/invitation.dart';

import '../../../tool.dart';

class OrderUseDetailScreen extends StatefulWidget {
  final int orderId;
  final int type;
  final bool isShow;

  OrderUseDetailScreen(this.orderId, this.type, {this.isShow = false});

  @override
  State<StatefulWidget> createState() => OrderUseDetailScreenState();
}

class OrderUseDetailScreenState extends State<OrderUseDetailScreen>
    with AutomaticKeepAliveClientMixin {
  // 订单详情
  MineOrderEntity _order = MineOrderEntity();
  bool _refund = false;
  List<ProductItemEntity> _productList = <ProductItemEntity>[];
  bool _isGrounding = false;

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
        _refund = _order.status == 6;
        // 已支付尾款的需要请求核销码
        if (_order.payFinalStatus == 1 && widget.isShow) {
          _requestCancelCodeInfo();
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 请求时间
  void _requestCancelCodeInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.cancelCode + widget.orderId.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      MineOrderCodeEntity codeEntity = MineOrderCodeEntity.fromJson(http.data);
      OrderDialog.showRefundCodeDialog(context, codeEntity);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _bottomAction() {
    if (widget.type == 2) {
      NavigatorUtil.pushPage(context, OrderCommentScreen(_order));
    } else if (widget.type == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryCreateScreen(),
        ),
      );
    } else if (widget.type == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => InvitationScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _bottomOtherTool() {
      String text = '';
      if (widget.type == 2) {
        text = '去评价';
      } else if (widget.type == 3) {
        text = '写日记';
      } else if (widget.type == 4) {
        text = '去晒单';
      }

      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _bottomAction,
        child: Container(
          height: 50,
          alignment: Alignment.center,
          color: XCColors.themeColor,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    Widget _bottomTool() {
      return Container(
        height: 50,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _order.isFree == 1
                      ? Container()
                      : Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.of(context)
                                  .push(
                                CupertinoPageRoute<int>(
                                  builder: (ctx) =>
                                      MineOrderRefundScreen(_order),
                                ),
                              )
                                  .then(
                                (value) {
                                  if (value == 1) {
                                    _requestOrderInfo();
                                  }
                                },
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: XCColors.mineOrderButtonColor,
                              child: Text(
                                '申请退款',
                                style: TextStyle(
                                    color: XCColors.tabNormalColor,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        if (_order.payFinalStatus == 1) {
                          // 核销码
                          _requestCancelCodeInfo();
                        } else {
                          // 支付尾款
                          if (_order.productName.isEmpty) {
                            return ToastHud.show(context, '订单异常');
                          } else {
                            NavigatorUtil.pushPage(
                                context, MineOrderFinalScreen(_order));
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        color: XCColors.themeColor,
                        child: Text(
                          _order.payFinalStatus == 1 ? '核销码' : '支付尾款',
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
                  body: OrderWidgets.orderBodyWidget(
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
            child: _order.status == 1
                ? (_refund
                    ? Container(
                        height: 50,
                        color: Colors.white,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          '该订单已退款',
                          style: TextStyle(
                            fontSize: 14,
                            color: XCColors.themeColor,
                          ),
                        ),
                      )
                    : _bottomTool())
                : _bottomOtherTool(),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
