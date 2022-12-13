import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/user.dart';

import 'code/verification_box.dart';

class LogoutCodeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LogoutCodeScreenState();
}

class LogoutCodeScreenState extends State<LogoutCodeScreen>
    with AutomaticKeepAliveClientMixin {
  String _mobile = '';
  String _code = '';
  String _codeText = '(60)重新获取验证码';
  Timer? _timer;
  int _countdownTime = 60;

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestUserInfo();
    });
  }

  /// 请求时间
  void _requestUserInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.userInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      InfoEntity entity = InfoEntity.fromJson(http.data);
      setState(() {
        _mobile = entity.phone!;
        _getCodeAction();
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _getCodeAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_countdownTime != 60) return;

    Map<String, String> params = Map();
    params['phone'] = _mobile;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.code, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '验证码已发送');

      const oneSec = const Duration(seconds: 1);
      if (_timer != null) _timer!.cancel();
      _timer = Timer.periodic(
        oneSec,
        (timer) {
          setState(
            () {
              if (_countdownTime < 1) {
                _timer!.cancel();
                _codeText = '重新获取验证码';
                _countdownTime = 60;
              } else {
                _countdownTime = _countdownTime - 1;
                _codeText = '（$_countdownTime）重新获取验证码';
              }
            },
          );
        },
      );
    } else {
      ToastHud.show(context, '发送失败');
    }
  }

  void _cancellationAction() async {
    if (_code.isEmpty) return ToastHud.show(context, '验证码不能为空');
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.logout, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '注销成功');
      UserManager.shared()!.logout();
      EventCenter.defaultCenter().fire(LogoutEvent(1));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '输入短信验证码', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 31),
            Text('我们已发送短信验证码到你的手机号',
                style: TextStyle(fontSize: 14, color: XCColors.tabNormalColor)),
            SizedBox(height: 10),
            Text(
              _mobile,
              style: TextStyle(
                fontSize: 21,
                color: XCColors.mainTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              width: double.infinity,
              height: 64,
              child: VerificationBox(
                textStyle: TextStyle(
                    fontSize: 36,
                    color: XCColors.bannerSelectedColor,
                    fontWeight: FontWeight.bold),
                itemWidget: 64,
                count: 4,
                borderColor: XCColors.changeMobileButtonColor,
                borderWidth: 2,
                borderRadius: 1,
                focusBorderColor: XCColors.bannerSelectedColor,
                onSubmitted: (value) {
                  _code = value;
                },
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _getCodeAction,
              child: Text(
                _codeText,
                style: TextStyle(fontSize: 14, color: XCColors.tabNormalColor),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _cancellationAction,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  '确认注销',
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
