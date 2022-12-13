import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/reason.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class MineOrderRefundScreen extends StatefulWidget {
  final MineOrderEntity entity;

  MineOrderRefundScreen(this.entity);

  @override
  State<StatefulWidget> createState() => MineOrderRefundScreenState();
}

class MineOrderRefundScreenState extends State<MineOrderRefundScreen>
    with AutomaticKeepAliveClientMixin {
  List _refundList = [
    {'city': '使用颜值金、优惠券重新下单'},
    {'city': '买错了，买多了'},
    {'city': '计划有变，不先做了'},
    {'city': '联系不上咨询师'},
    {'city': '联系上了咨询师，但他档期太满'},
    {'city': '改找别的咨询师做这个项目'},
    {'city': '改做这个咨询师/商家的其他项目'},
    {'city': '对商家、咨询师不满意'},
    {'city': '反馈其他原因'}
  ];
  List<HomeDistanceEntity> _refundEntityList = <HomeDistanceEntity>[];
  String _result = '';
  bool _isGrounding = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();

    // 筛选初始化
    _refundEntityList = _refundList.map((value) {
      return HomeDistanceEntity.fromJson(value);
    }).toList();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    if (_isGrounding) {
      setState(() {
        _refundList = [
          {'city': '使用颜值金、优惠券重新下单'},
          {'city': '买错了，买多了'},
          {'city': '计划有变，不先做了'},
          {'city': '联系不上技师'},
          {'city': '联系上了技师，但他档期太满'},
          {'city': '改找别的技师做这个项目'},
          {'city': '改做这个技师/门店的其他项目'},
          {'city': '对门店、技师不满意'},
          {'city': '反馈其他原因'}
        ];
      });
    }
  }

  void _applyAction() {
    if (_result.isEmpty) return ToastHud.show(context, '请选择退款原因');

    OrderDialog.showRefundDialog(context, () async {
      Map<String, dynamic> params = Map();
      params['orderId'] = widget.entity.id.toString();
      params['reason'] = _result;

      ToastHud.loading(context);
      var http = await HttpManager.post(DsApi.refundOrder, params, context);
      ToastHud.dismiss();
      if (http.code == 200) {
        ToastHud.show(context, http.message!);
        Navigator.pop(context, 1);
      } else {
        ToastHud.show(context, http.message!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _refundItem(String title, String value) {
      return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(title,
                    style: TextStyle(
                        fontSize: 14, color: XCColors.mainTextColor))),
            Container(height: 1, color: XCColors.homeDividerColor),
            Container(
                height: 37,
                alignment: Alignment.centerLeft,
                child: Text(value,
                    style:
                        TextStyle(fontSize: 12, color: XCColors.mainTextColor)))
          ]));
    }

    Widget _refundCheckItem(String title) {
      return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(title,
                    style: TextStyle(
                        fontSize: 14, color: XCColors.mainTextColor))),
            Container(height: 1, color: XCColors.homeDividerColor),
            Column(
              children: _refundEntityList.map((e) {
                return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _result = e.city;
                      setState(() {
                        _refundEntityList.forEach((element) {
                          element.isSelected = false;
                        });

                        e.isSelected = true;
                      });

                      if (e.city.contains('反馈')) {
                        Navigator.push(
                                context,
                                CupertinoPageRoute<String>(
                                    builder: (ctx) =>
                                        MineOrderRefundReasonScreen()))
                            .then((value) {
                          if (value!.isEmpty) return;
                          _result = value;
                        });
                      }
                    },
                    child: Container(
                        height: 37,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1,
                                    color: XCColors.homeDividerColor))),
                        child: Row(children: [
                          Expanded(
                              child: Text(e.city,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: XCColors.mainTextColor))),
                          Image.asset(
                              e.isSelected
                                  ? 'assets/images/box/box_check_selected.png'
                                  : 'assets/images/box/box_check_normal.png',
                              width: 20,
                              height: 20)
                        ])));
              }).toList(),
            )
          ]));
    }

    Widget _bodyWidget() {
      return SingleChildScrollView(
          child: Column(children: [
        SizedBox(height: 10),
        _refundItem('订单信息', ' 订单编号：${widget.entity.orderSn}'),
        SizedBox(height: 10),
        _refundItem('退还金额', ' 现金：${widget.entity.payAmount}元'),
        SizedBox(height: 10),
        _refundCheckItem('退款原因'),
        SizedBox(height: 80),
        CommonWidgets.mainButton('申请退款', _applyAction),
        SizedBox(height: 35)
      ]));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '申请退款', () {
          Navigator.pop(context);
        }),
        body: _bodyWidget());
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
