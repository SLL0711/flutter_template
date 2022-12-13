import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/consult/entity.dart';
import 'package:flutter_medical_beauty/ui/video/pay_success.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import '../../http.dart';
import '../../toast.dart';

class VideoPayScreen extends StatefulWidget {
  final int productCategoryId, memberId;
  final DoctorItemEntity doctor;

  VideoPayScreen(this.productCategoryId, this.memberId, this.doctor);

  @override
  State<StatefulWidget> createState() => VideoPayScreenState();
}

class VideoPayScreenState extends State<VideoPayScreen>
    with AutomaticKeepAliveClientMixin {
  String _selectedDate = '立即咨询';
  int _waitingTime = 0;
  int _selectedType = 1; // 0 我会发起咨询  1 咨询师发起咨询
  ConsultOrderEntity _order = ConsultOrderEntity();

  @override
  void initState() {
    // 微信支付回调
    fluwx.weChatResponseEventHandler.listen((res) {
      if (res is fluwx.WeChatPaymentResponse) {
        print("pay :${res.isSuccessful}");
        if (res.isSuccessful) {
          _paySuccess();
        } else {
          ToastHud.show(context, '支付失败，请重试！');
        }
      }
    });
    Future.delayed(Duration.zero, _requestWaitingTime);
    super.initState();
  }

  void _selectedTypeAction(int type) {
    setState(() {
      _selectedType = type;
    });
  }

  /// 选择时间
  void _selectedDateAction() {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(),
        theme: DatePickerTheme(
          cancelStyle: TextStyle(
            fontSize: 16,
            color: XCColors.tabNormalColor,
          ),
          doneStyle: TextStyle(
            fontSize: 16,
            color: XCColors.mainTextColor,
          ),
        ),
        showTitleActions: true, onConfirm: (date) {
      setState(
        () {
          bool isNow =
              DateTime.now().add(Duration(minutes: 30)).compareTo(date) >= 0;
          if (isNow) {
            _selectedDate = '立即咨询';
          } else {
            _selectedDate =
                DateUtil.formatDate(date, format: DateFormats.y_mo_d_h_m);
          }
          _requestWaitingTime();
        },
      );
    }, locale: LocaleType.zh);
  }

  /// 确认支付
  void _requestWaitingTime() async {
    Map<String, dynamic> params = new Map();
    params['doctorId'] = widget.doctor.id;
    params['memberId'] = widget.memberId;
    params['productCategoryIId'] = widget.productCategoryId;
    params['sponsorType'] = _selectedType;
    params['type'] = _selectedDate == '立即咨询' ? 0 : 1;
    if (_selectedDate != '立即咨询') {
      params['subscribeBeginTime'] = _selectedDate;
      DateTime date = DateTime.parse(_selectedDate).add(Duration(minutes: 30));
      params['subscribeEndTime'] =
          DateUtil.formatDate(date, format: DateFormats.y_mo_d_h_m);
    }
    ToastHud.loading(context);
    var http =
        await HttpManager.post(DsApi.consultWaitingTime, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        List<dynamic> list = http.data ?? [];
        _waitingTime = list.length * 30;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 确认支付
  void _surePay() async {
    Map<String, dynamic> params = new Map();
    params['doctorId'] = widget.doctor.id;
    params['memberId'] = widget.memberId;
    params['productCategoryIId'] = widget.productCategoryId;
    params['sponsorType'] = _selectedType;
    params['type'] = _selectedDate == '立即咨询' ? 0 : 1;
    if (_selectedDate != '立即咨询') {
      params['subscribeBeginTime'] = _selectedDate;
      DateTime date = DateTime.parse(_selectedDate).add(Duration(minutes: 30));
      params['subscribeEndTime'] =
          DateUtil.formatDate(date, format: DateFormats.y_mo_d_h_m);
    }
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.addVideoOrder, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      _order = ConsultOrderEntity.fromJson(http.data);
      _weChatPay();
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 微信支付
  void _weChatPay() async {
    bool isInstalled = await fluwx.isWeChatInstalled;
    if (!isInstalled) {
      ToastHud.show(context, '请先安装微信');
      return;
    }
    Map<String, dynamic> params = Map();
    params['payType'] = '1';
    //支付来源 0订单支付 1尾款支付 2购买会员 3提现 4入驻
    params['source'] = 5;
    params['sourceId'] = _order.id;
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

  void _paySuccess() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPaySuccessScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '咨询', () {
        Navigator.pop(context);
      }),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              child: Column(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _selectedDateAction,
                    child: Container(
                      height: 61,
                      color: Colors.white,
                      padding: const EdgeInsets.only(left: 17, right: 14),
                      child: Row(
                        children: [
                          Text(
                            '咨询时间',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFF191B6),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                              child: Text(
                            _selectedDate,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF999999),
                            ),
                          )),
                          SizedBox(width: 10),
                          CommonWidgets.grayRightArrow()
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 9),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: RichText(
                      text: TextSpan(
                        text: '*',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFFFC8A99),
                        ),
                        children: [
                          TextSpan(
                            text: '请留意自己选择的时间进行咨询，咨询时请保持光线充足',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: _waitingTime == 0 ? 0 : 10),
                  Offstage(
                    offstage: _waitingTime == 0,
                    child: Container(
                      height: 27,
                      margin: const EdgeInsets.symmetric(horizontal: 13),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Color(0xFFF7E8EA)),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            child: Image.asset(
                                'assets/images/video/video_tips.png'),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '提示：所选咨询时间前面还有${_waitingTime ~/ 30}人，预计等待$_waitingTime分钟',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFD7788),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 61,
                    color: Colors.white,
                    padding: const EdgeInsets.only(left: 17, right: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            '咨询方式',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFFF191B6),
                            ),
                          ),
                        ),
                        Text(
                          '咨询师发起咨询',
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 30,
              right: 16,
              left: 16,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _surePay,
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: XCColors.themeColor,
                  ),
                  child: Text(
                    '支付',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
