import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/login/entity.dart';
import 'package:flutter_medical_beauty/user.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';

import '../../tool.dart';

class BindPhoneScreen extends StatefulWidget {
  final String openId;

  BindPhoneScreen(this.openId);

  @override
  State<StatefulWidget> createState() => BindPhoneScreenState();
}

class BindPhoneScreenState extends State<BindPhoneScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  TextEditingController _mobileTextController = TextEditingController();
  TextEditingController _codeTextController = TextEditingController();
  String _codeText = '获取验证码';
  bool _isLogin = false;
  Timer? _timer;
  int _countdownTime = 60;
  String _xinGeAccount = '';

  @override
  void dispose() {
    _mobileTextController.dispose();
    _codeTextController.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _mobileTextController.addListener(() {
      setState(() {
        _isLogin = _mobileTextController.text.isNotEmpty &&
            _codeTextController.text.isNotEmpty;
      });
    });
    _codeTextController.addListener(() {
      setState(() {
        _isLogin = _mobileTextController.text.isNotEmpty &&
            _codeTextController.text.isNotEmpty;
      });
    });
    Future.delayed(Duration.zero, _initParams);
  }

  void _initParams() async {
    _xinGeAccount = await Tool.getString('pushToken');
  }

  /// 按钮的执行
  void _loginAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (!_isLogin) {
      return;
    }

    Map<String, String> params = Map();
    params['phone'] = _mobileTextController.text;
    params['code'] = _codeTextController.text;
    params['openId'] = widget.openId;
    params['xinGeAccount'] = _xinGeAccount;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.wechatBindPhone, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      LoginEntity entity = LoginEntity.fromJson(http.data);
      String token = entity.tokenHead + ' ' + entity.token;
      // 缓存
      ToastHud.show(context, '登录成功');
      UserManager.shared()!.saveToken(token);
      // Im登录
      try {
        await EMClient.getInstance.login(entity.phone, entity.phone);
      } on EMError catch (e) {} finally {}
      EventCenter.defaultCenter().fire(RefreshMineEvent(''));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ToastHud.show(context, '登录失败');
    }
  }

  void _getCodeAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_mobileTextController.text.isEmpty)
      return ToastHud.show(context, '请输入手机号');

    if (_countdownTime != 60) return;

    Map<String, String> params = Map();
    params['phone'] = _mobileTextController.text;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.code, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '验证码已发送');

      const oneSec = const Duration(seconds: 1);
      if (_timer != null) _timer!.cancel();
      _timer = Timer.periodic(oneSec, (timer) {
        setState(() {
          if (_countdownTime < 1) {
            _timer!.cancel();
            _codeText = '重新获取';
            _countdownTime = 60;
          } else {
            _countdownTime = _countdownTime - 1;
            _codeText = '（$_countdownTime）重新获取';
          }
        });
      });
    } else {
      ToastHud.show(context, '发送失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/images/home/back.png",
                      width: 28, height: 28),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip);
            })),
        body: SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Stack(children: [
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                                height: 8, color: XCColors.themeColor)),
                        Text("绑定手机号",
                            style: TextStyle(
                                fontSize: 30,
                                color: XCColors.mainTextColor,
                                fontWeight: FontWeight.bold))
                      ]),
                      SizedBox(height: 60),
                      Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: XCColors.homeDividerColor))),
                          child: TextField(
                              controller: _mobileTextController,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 16, color: XCColors.mainTextColor),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入手机号码",
                                  hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: XCColors.tabNormalColor)))),
                      Container(
                          height: 50,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1,
                                      color: XCColors.homeDividerColor))),
                          child: Row(children: [
                            Expanded(
                                child: TextField(
                                    controller: _codeTextController,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: XCColors.mainTextColor),
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "验证码",
                                        hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: XCColors.tabNormalColor)))),
                            GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: _getCodeAction,
                                child: Container(
                                    height: double.infinity,
                                    width: 110,
                                    alignment: Alignment.centerRight,
                                    child: Text(_codeText,
                                        style: TextStyle(
                                            color: XCColors.bannerSelectedColor,
                                            fontSize: 14))))
                          ])),
                      SizedBox(height: 50),
                      GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: _loginAction,
                          child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: _isLogin
                                      ? XCColors.themeColor
                                      : XCColors.buttonDisableColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: XCColors.buttonShadowColor,
                                        blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(25),
                                  )),
                              child: Text("确定",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  )))),
                      SizedBox(height: 50)
                    ]))));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
