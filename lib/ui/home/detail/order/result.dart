import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/pay.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/order/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/order/use_detail.dart';

import '../../../../api.dart';
import '../../../../event_center.dart';
import '../../../../http.dart';
import '../../../../toast.dart';
import '../../../../tool.dart';

class OrderPayResultScreen extends StatefulWidget {
  final int result, orderId;

  OrderPayResultScreen(this.result, this.orderId);

  @override
  State<StatefulWidget> createState() => OrderPayResultScreenState();
}

class OrderPayResultScreenState extends State<OrderPayResultScreen>
    with AutomaticKeepAliveClientMixin {
  // 猜你喜欢
  List<ProductItemEntity> _productList = <ProductItemEntity>[];

  @override
  void initState() {
    Future.delayed(Duration.zero, _requestGuess);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);

    void _backHome() {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }

    void _pushOrderView() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => widget.result == 1
              ? OrderUseDetailScreen(widget.orderId, 1)
              : OrderDetailScreen(widget.orderId),
        ),
      );
    }

    void _cancelAction() async {
      Map<String, dynamic> params = Map();
      params['orderId'] = widget.orderId.toString();

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

    void _cancelOrderView() {
      OrderDialog.showCancelDialog(context, _cancelAction);
    }

    void _againPayView() {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderPayScreen(widget.orderId),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: widget.result == 1
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              title: Text(
                '支付成功',
                style: TextStyle(
                    fontSize: 18,
                    color: XCColors.mainTextColor,
                    fontWeight: FontWeight.bold),
              ),
            )
          : CityWidgets.cityAppBar(
              context,
              '支付失败',
              () {
                Navigator.pop(context);
              },
            ),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: NestedScrollView(
          body: OrderWidgets.orderBodyWidget(context, _productList),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    widget.result == 1
                        ? OrderWidgets.paySuccessView(
                            context, _backHome, _pushOrderView)
                        : OrderWidgets.payFailureView(
                            context, _cancelOrderView, _againPayView),
                    Container(height: 10, color: XCColors.homeDividerColor),
                    OrderWidgets.payTipWidget(context)
                  ],
                ),
              ),
            ];
          },
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
