import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/category.dart';
import 'package:flutter_picker/flutter_picker.dart';

class GoldWithdrawScreen extends StatefulWidget {
  final double amount;

  GoldWithdrawScreen(this.amount);

  @override
  State<StatefulWidget> createState() => GoldWithdrawScreenState();
}

class GoldWithdrawScreenState extends State<GoldWithdrawScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _nameTextEditingController =
      new TextEditingController();
  TextEditingController _amountTextEditingController =
      new TextEditingController();
  TextEditingController _alipayTextEditingController =
      new TextEditingController();
  int _withdrawWay = 1;

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _amountTextEditingController.dispose();
    _alipayTextEditingController.dispose();
    super.dispose();
  }

  void _selectedWay() {
    FocusScope.of(context).requestFocus(FocusNode());

    Picker picker = Picker(
        height: 200,
        itemExtent: 35,
        adapter: PickerDataAdapter<String>(pickerdata: ['微信', '支付宝']),
        changeToFirst: true,
        columnPadding: const EdgeInsets.all(8.0),
        textAlign: TextAlign.left,
        cancelText: '取消',
        confirmText: '确定',
        cancelTextStyle:
            TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
        confirmTextStyle:
            TextStyle(fontSize: 16, color: XCColors.mainTextColor),
        textStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
        selectedTextStyle:
            TextStyle(fontSize: 18, color: XCColors.mainTextColor),
        onConfirm: (Picker picker, List value) {
          String result = picker.getSelectedValues()[0];
          _withdrawWay = result == '微信' ? 1 : 2;
        });
    picker.showModal(context);
  }

  void _withdrawAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    Map<String, String> params = Map();
    if (_nameTextEditingController.text.isEmpty)
      return ToastHud.show(context, '请输入真实姓名');
    params['realName'] = _nameTextEditingController.text;
    if (_withdrawWay == 1) {
      params['withdrawType'] = '0';
    } else {
      params['withdrawType'] = '1';
      if (_alipayTextEditingController.text.isEmpty)
        return ToastHud.show(context, '请输入支付宝账号');
      params['account'] = _alipayTextEditingController.text;
    }
    if (_amountTextEditingController.text.isEmpty)
      return ToastHud.show(context, '请输入提现金额');
    params['withdrawAmount'] = _amountTextEditingController.text;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.withdraw, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
      EventCenter.defaultCenter().fire(RefreshMineEvent('1'));
      Navigator.pop(context, '1');
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _textFiledInfoView(String title, String hint,
        TextEditingController textEditingController) {
      return Container(
          height: 50,
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child: Row(children: [
            Container(
                width: 75,
                child: Text(title,
                    style: TextStyle(
                        fontSize: 14, color: XCColors.mainTextColor))),
            SizedBox(width: 20),
            Expanded(
                child: TextField(
                    controller: textEditingController,
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: 12, color: XCColors.mainTextColor),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: hint,
                        hintStyle: TextStyle(
                            fontSize: 12, color: XCColors.tabNormalColor))))
          ]));
    }

    Widget _headerInfoView() {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child: Column(children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _selectedWay,
                child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1, color: XCColors.homeDividerColor))),
                    child: Row(children: [
                      Container(
                          width: 75,
                          child: Text('提现方式',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: XCColors.mainTextColor))),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(_withdrawWay == 1 ? '微信' : '支付宝',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: XCColors.tabNormalColor))),
                      Image.asset(
                          'assets/images/home/home_detail_arrow_down.png',
                          width: 14,
                          height: 7)
                    ]))),
            _textFiledInfoView('真实姓名', _withdrawWay == 1 ? '微信' : '姓名',
                _nameTextEditingController),
            Offstage(
                offstage: _withdrawWay == 1,
                child: _textFiledInfoView(
                    '支付宝账号', '请输入您的支付宝账号', _alipayTextEditingController)),
            _textFiledInfoView('提现金额', '当前可提现金额¥${widget.amount}',
                _amountTextEditingController),
            SizedBox(height: 20),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _withdrawAction,
                child: Container(
                    width: 200,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: XCColors.themeColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text('申请提现',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)))),
            SizedBox(height: 20)
          ]));
    }

    Widget _ruleInfoView() {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(6))),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(height: 17),
            Container(
                alignment: Alignment.center,
                child: Text('提现须知',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: XCColors.mainTextColor))),
            SizedBox(height: 10),
            Text('1.如何提现？',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: XCColors.mainTextColor)),
            RichText(
                text: TextSpan(
                    text: '进入“',
                    style:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                    children: [
                  TextSpan(
                      text: '我的→Star积分→去提现',
                      style: TextStyle(
                          fontSize: 12, color: XCColors.bannerSelectedColor)),
                  TextSpan(
                      text:
                          '”，输入认证信息进行提现；应国家交易平台资金提现需实名认证要求，目前雀斑平台全部用户可提现到支付宝/微信。',
                      style: TextStyle(
                          fontSize: 12, color: XCColors.tabNormalColor))
                ])),
            SizedBox(height: 20),
            Text('2. 提现多久能到账？',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: XCColors.mainTextColor)),
            Text(
                '提现成功后，资金会在48小时内到达您选择的提现账号。（因平台返现是自动返现，可能会受银行转账限制而导致返现未到账，请尽快联系在线客服为您处理噢~）',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 20),
            Text('3. 提现是否有额度限制？',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: XCColors.mainTextColor)),
            Text('每个用户当天提现总金额限额为50000元，最低提现金额为50元。',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 20),
            Text('4. 提现是否需要手续费？',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: XCColors.mainTextColor)),
            Text(
                '目前是不需要手续费的。（前期）\n提现需要收取申请金额1%的手续费，提现金额最低为50元；系统24小时受理用户提现申请。该提现规则于2019年04月25日起生效。（后期）',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(height: 20)
          ]));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '提现', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(children: [
                  SizedBox(height: 10),
                  _headerInfoView(),
                  SizedBox(height: 10),
                  _ruleInfoView()
                ]))));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
