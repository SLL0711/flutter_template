import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/login/bind.dart';
import 'package:flutter_medical_beauty/ui/login/entity.dart';
import 'package:flutter_medical_beauty/user.dart';
import 'package:fluwx/fluwx.dart' as fluwx;
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:tpns_flutter_plugin/tpns_flutter_plugin.dart';

import 'article.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  TextEditingController _mobileTextController = TextEditingController();
  TextEditingController _codeTextController = TextEditingController();
  TextEditingController _inviteTextController = TextEditingController();
  String _codeText = '获取验证码';
  bool _isAgree = false, _isLogin = false;
  Timer? _timer;
  int _countdownTime = 60;
  String _xinGeAccount = '';

  @override
  void dispose() {
    _mobileTextController.dispose();
    _codeTextController.dispose();
    _inviteTextController.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _mobileTextController.addListener(() {
      setState(() {
        _isLogin = _isAgree &&
            _mobileTextController.text.isNotEmpty &&
            _codeTextController.text.isNotEmpty;
      });
    });
    _codeTextController.addListener(() {
      setState(() {
        _isLogin = _isAgree &&
            _mobileTextController.text.isNotEmpty &&
            _codeTextController.text.isNotEmpty;
      });
    });

    Future.delayed(Duration.zero, _initParams);

    fluwx.weChatResponseEventHandler.distinct((a, b) => a == b).listen((event) {
      if (event is fluwx.WeChatAuthResponse) {
        int errCode = event.errCode;
        print('微信登录返回值: ErrCode :$errCode  code: ${event.code}');
        if (errCode == 0) {
          String code = event.code!;
          // 把微信登录返回的code传给后台
          _weChatAuth(code);
          ToastHud.show(context, '用户同意授权成功');
        } else if (errCode == -4) {
          ToastHud.show(context, '用户拒绝授权');
        } else if (errCode == -2) {
          ToastHud.show(context, '用户取消授权');
        }
      }
    });
  }

  void _initParams() async {
    String inviteCode = await Tool.getString('inviteCode');
    _inviteTextController.text = inviteCode;
    _xinGeAccount = await Tool.getString('pushToken');
  }

  void _weChatLoginAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    fluwx
        .sendWeChatAuth(scope: 'snsapi_userinfo', state: 'wechat_sdk_login')
        .then((value) {
      if (!value) {
        ToastHud.show(context, '没有安装微信，请安装微信后使用该功能');
      }
    });
  }

  void _weChatAuth(String code) async {
    print('========== code ====' + code);
    Map<String, String> params = Map();
    params['openId'] = code;
    params['xinGeAccount'] = _xinGeAccount;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.wechatLogin, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      print('========== http.data ====' + http.data);
      LoginEntity entity = LoginEntity.fromJson(http.data);
      String token = entity.tokenHead + ' ' + entity.token;
      // 缓存
      ToastHud.show(context, '登录成功');
      UserManager.shared()!.saveToken(token);
      // Im登录
      try {
        await EMClient.getInstance.login(entity.phone, entity.phone);
      } on EMError catch (e) {
      } finally {}
      EventCenter.defaultCenter().fire(RefreshMineEvent(''));
      Navigator.pop(context);
    } else if (http.code == 1003) {
      // 绑定手机号
      NavigatorUtil.pushPage(context, BindPhoneScreen(code), needLogin: false);
    } else {
      ToastHud.show(context, '登录失败');
    }
  }

  /// 按钮的执行
  void _loginAction() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (!_isAgree) {
      ToastHud.show(context, '请先阅读并同意协议');
      return;
    }
    if (!_isLogin) {
      return;
    }
    Tool.saveBool('isAgree', _isAgree);
    if (_mobileTextController.text.isEmpty) {
      return ToastHud.show(context, '请输入手机号');
    }
    if (!Tool.isChinaPhoneLegal(_mobileTextController.text)) {
      return ToastHud.show(context, '请输入正确手机号');
    }
    if (_codeTextController.text.isEmpty) {
      return ToastHud.show(context, '请输入验证码');
    }
    Map<String, String> params = Map();
    params['phone'] = _mobileTextController.text;
    params['code'] = _codeTextController.text;
    params['inviteCode'] = _inviteTextController.text;
    params['xinGeAccount'] = _xinGeAccount;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.login, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      LoginEntity entity = LoginEntity.fromJson(http.data);
      String token = entity.tokenHead + ' ' + entity.token;
      // 缓存
      ToastHud.show(context, '登录成功');
      UserManager.shared()!.saveToken(token);
      // 推送设置账号
      XgFlutterPlugin tpush = new XgFlutterPlugin();
      tpush.cleanAccounts();
      tpush.setAccount(_xinGeAccount, AccountType.UNKNOWN);
      // Im登录
      try {
        await EMClient.getInstance.login(entity.phone, entity.phone);
      } on EMError catch (e) {
      } finally {}
      EventCenter.defaultCenter().fire(RefreshMineEvent(''));
      Navigator.pop(context);
    } else {
      ToastHud.show(context, '登录失败');
    }
  }

  void _getCodeAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_mobileTextController.text.isEmpty) {
      return ToastHud.show(context, '请输入手机号');
    }
    if (!Tool.isChinaPhoneLegal(_mobileTextController.text)) {
      return ToastHud.show(context, '请输入正确手机号');
    }

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
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset(
                "assets/images/home/back.png",
                width: 28,
                height: 28,
              ),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 8,
                      color: XCColors.themeColor,
                    ),
                  ),
                  Text(
                    "快速登录",
                    style: TextStyle(
                      fontSize: 30,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "无需注册，输入手机号即可登录",
                style: TextStyle(
                  fontSize: 18,
                  color: XCColors.mainTextColor,
                ),
              ),
              SizedBox(height: 47),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: XCColors.homeDividerColor,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _mobileTextController,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: XCColors.mainTextColor,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "请输入手机号码",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: XCColors.tabNormalColor,
                    ),
                  ),
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: XCColors.homeDividerColor,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _codeTextController,
                        keyboardType: TextInputType.number,
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16, color: XCColors.mainTextColor),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "验证码",
                          hintStyle: TextStyle(
                            fontSize: 16,
                            color: XCColors.tabNormalColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _getCodeAction,
                      child: Container(
                        height: double.infinity,
                        width: 110,
                        alignment: Alignment.centerRight,
                        child: Text(
                          _codeText,
                          style: TextStyle(
                            color: XCColors.bannerSelectedColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1,
                      color: XCColors.homeDividerColor,
                    ),
                  ),
                ),
                child: TextField(
                  controller: _inviteTextController,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "可选输入邀请码",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: XCColors.tabNormalColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(
                    () {
                      _isAgree = !_isAgree;
                      _isLogin = _isAgree &&
                          _mobileTextController.text.isNotEmpty &&
                          _codeTextController.text.isNotEmpty;
                    },
                  );
                },
                child: Container(
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        child: Image.asset(
                            _isAgree
                                ? 'assets/images/box/box_check_selected.png'
                                : 'assets/images/box/box_check_normal.png',
                            fit: BoxFit.cover),
                      ),
                      SizedBox(width: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        alignment: Alignment.center,
                        child: RichText(
                          text: TextSpan(
                            text: '登录即代表同意雀斑',
                            style: TextStyle(
                                fontSize: 12, color: XCColors.goodsGrayColor),
                            children: [
                              TextSpan(
                                  text: '《用户协议》',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: XCColors.bannerSelectedColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      NavigatorUtil.pushPage(
                                          context, ArticleScreen('asdessaea'),
                                          needLogin: false);
                                    }),
                              TextSpan(
                                text: '《隐私政策》',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: XCColors.bannerSelectedColor),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    NavigatorUtil.pushPage(
                                        context, ArticleScreen('sqafqm4bm'),
                                        needLogin: false);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _loginAction,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isLogin
                        ? XCColors.themeColor
                        : XCColors.buttonDisableColor,
                    boxShadow: [
                      BoxShadow(
                          color: XCColors.buttonShadowColor, blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  child: Text(
                    "登录",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "未注册过雀斑的用户会自动帮你创建账号",
                  style: TextStyle(
                    fontSize: 12,
                    color: XCColors.goodsGrayColor,
                  ),
                ),
              ),
              SizedBox(height: 50),
              // Center(
              //   child: GestureDetector(
              //     behavior: HitTestBehavior.opaque,
              //     onTap: _weChatLoginAction,
              //     child: Image.asset(
              //       'assets/images/home/home_detail_share_wechat.png',
              //       width: 60,
              //       height: 60,
              //     ),
              //   ),
              // ),
              // SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
