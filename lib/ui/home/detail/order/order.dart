import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/insurance.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/pay.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/result.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';

class DetailOrderView extends StatefulWidget {
  final int productId,
      productSkuId,
      doctorId,
      shoppingCardId,
      groupType,
      groupTeamId;

  DetailOrderView(
    this.productId,
    this.productSkuId,
    this.doctorId, {
    this.shoppingCardId = 0,
    this.groupType = -1,
    this.groupTeamId = 0,
  });

  @override
  State<StatefulWidget> createState() => DetailOrderViewState();
}

class DetailOrderViewState extends State<DetailOrderView>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController = TextEditingController();
  String _selectedDate = '请选择';
  String _insuranceObjectName = '';
  bool _isBuyInsurance = false;
  bool _isExchange = false;
  DetailOrderEntity _orderEntity = DetailOrderEntity();
  OrderInsuranceEntity _entity = OrderInsuranceEntity();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      requestOrderInfo();
      _requestUserInfo();
    });
  }

  void requestOrderInfo() async {
    Map<String, dynamic> params = Map();
    params['productId'] = widget.productId.toString();
    params['productSkuId'] = widget.productSkuId.toString();
    params['isGroup'] = widget.groupType == -1 ? 0 : 1;

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.productOrder + widget.productId.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _orderEntity = DetailOrderEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
      Navigator.pop(context);
    }
  }

  void _requestUserInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      MineEntity entity = MineEntity.fromJson(http.data);
      setState(() {
        _insuranceObjectName = entity.nickName!;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _selectedDateAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    DateTime dateTime = DateTime.now();
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            cancelStyle:
                TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
            doneStyle: TextStyle(fontSize: 16, color: XCColors.mainTextColor)),
        showTitleActions: true,
        minTime: DateTime(dateTime.year, dateTime.month, dateTime.day),
        onConfirm: (date) {
      List<String> dates = date.toString().split(' ');
      String birthday = dates.first;
      setState(() {
        _selectedDate = birthday;
      });
    }, currentTime: dateTime, locale: LocaleType.zh);
  }

  void _buyInsuranceAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isBuyInsurance = !_isBuyInsurance;
    });
  }

  void _pushChangeAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.push(
            context,
            CupertinoPageRoute<OrderInsuranceEntity>(
                builder: (ctx) =>
                    DetailOrderInsuranceView(_orderEntity.guaranteeAmount)))
        .then((value) {
      if (value == null) return;
      setState(() {
        _entity = value;
        _insuranceObjectName = value.name;
      });
    });
  }

  void _exChangeAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isExchange = !_isExchange;
    });
  }

  void _confirmAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_selectedDate == '请选择') return ToastHud.show(context, '请选择到店时间');
    Map<String, dynamic> params = Map();
    params['arriveTime'] = _selectedDate;
    // 0正常订单 1秒杀订单 2体验订单
    params['orderType'] = _orderEntity.isMemberFreeTrial == 1
        ? '2'
        : widget.groupType == -1
            ? '0'
            : 1;
    params['type'] = widget.shoppingCardId > 0 ? 1 : 0;
    params['productSkuId'] = widget.productSkuId.toString();
    params['doctorId'] = widget.doctorId;
    if (widget.shoppingCardId > 0) {
      params['cartItemId'] = widget.shoppingCardId;
    }
    if (widget.groupType != -1) {
      params['groupType'] = widget.groupType;
      if (widget.groupType == 1) {
        params['groupTeamId'] = widget.groupTeamId;
      }
    }

    if (_orderEntity.isMemberFreeTrial != 1) {
      params['guaranteeAmount'] = _orderEntity.guaranteeAmount.toString();
      params['isBeautyGold'] = _isExchange ? '1' : '0';
      params['isInsurance'] = _isBuyInsurance ? '1' : '0';

      Map<String, dynamic> insuranceDTO = Map();
      if (_insuranceObjectName.isNotEmpty) {
        insuranceDTO['insuranceObjectName'] = _insuranceObjectName;
      }
      if (_entity.idCard.isNotEmpty) {
        insuranceDTO['insuranceObjectIdCard'] = _entity.idCard;
        insuranceDTO['insuranceObjectMobile'] = _entity.mobile;
      }
      if (insuranceDTO.isNotEmpty) {
        params['insuranceDTO'] = insuranceDTO;
      }
    }
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.createOrder, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (widget.shoppingCardId > 0) {
        EventCenter.defaultCenter().fire(RefreshShoppingCartEvent('购物车购买'));
      }
      DetailOrderPayEntity entity = DetailOrderPayEntity.fromJson(http.data);
      if (entity.payAmount == 0 || entity.payAmount == 0.0) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => OrderPayResultScreen(1, entity.orderId),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (builder) => OrderPayScreen(entity.orderId)),
        );
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '填写订单', () {
        Navigator.pop(context);
      }),
      body: _orderEntity.name.isEmpty
          ? Container()
          : _orderEntity.isMemberFreeTrial == 1
              ? Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            OrderWidgets.orderFreeInfo(context, _selectedDate,
                                _orderEntity, _selectedDateAction)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: OrderWidgets.orderFreeBottomTool(
                          context, _confirmAction),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            OrderWidgets.orderInfo(
                              context,
                              _selectedDate,
                              _orderEntity,
                              _selectedDateAction,
                            ),
                            Offstage(
                              offstage: _orderEntity.isAllPay == 1,
                              child: Column(
                                children: [
                                  SizedBox(height: 10),
                                  OrderWidgets.orderTipInfo(context, '预约金小计：',
                                      '¥${_orderEntity.subscribePrice}'),
                                  SizedBox(height: 1),
                                  OrderWidgets.orderTipInfo(context, '尾款小计：',
                                      '¥${_orderEntity.finalPrice}'),
                                ],
                              ),
                            ),
                            SizedBox(height: 1),
                            OrderWidgets.orderInsuranceInfo(
                              context,
                              _isBuyInsurance,
                              _orderEntity,
                              _insuranceObjectName,
                              _buyInsuranceAction,
                              _pushChangeAction,
                            ),
                            SizedBox(height: 20),
                            OrderWidgets.orderMemberInfo(context),
                            OrderWidgets.orderExchangeInfo(
                              context,
                              _isExchange,
                              _orderEntity,
                              _exChangeAction,
                            ),
                            SizedBox(height: 20),
                            OrderWidgets.orderEditInfo(
                              context,
                              _textEditingController,
                            ),
                            SizedBox(height: 120)
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: OrderWidgets.orderBottomTool(
                        context,
                        _isBuyInsurance,
                        _orderEntity,
                        _confirmAction,
                      ),
                    ),
                  ],
                ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
