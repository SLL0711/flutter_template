import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/account/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/widgets.dart';

class MobileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MobileScreenState();
}

class MobileScreenState extends State<MobileScreen>
    with AutomaticKeepAliveClientMixin {
  String _mobile = '';
  TextEditingController _mobileTextController = TextEditingController();
  TextEditingController _codeTextController = TextEditingController();
  String _codeText = '获取验证码';
  Timer? _timer;
  int _countdownTime = 60;
  bool _isLogin = false;

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
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 按钮的执行
  void _changeAction() async {
    if (!_isLogin) return;
    FocusScope.of(context).requestFocus(FocusNode());

    if (_mobile.isNotEmpty && _mobile == _mobileTextController.text) {
      return ToastHud.show(context, '请输入新的手机号码');
    }

    if (!Tool.isChinaPhoneLegal(_mobileTextController.text)) {
      return ToastHud.show(context, '请输入正确的手机号');
    }

    Map<String, String> params = Map();
    params['newPhone'] = _mobileTextController.text;
    params['code'] = _codeTextController.text;

    ToastHud.loading(context);
    var http =
        await HttpManager.post(DsApi.modifyMemberPhoneNumber, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '修改成功');
      Navigator.pop(context);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _getCodeAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_mobileTextController.text.isEmpty) {
      return ToastHud.show(context, '请输入手机号');
    }
    if (!Tool.isChinaPhoneLegal(_mobileTextController.text)) {
      return ToastHud.show(context, '请输入正确的手机号');
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
            _codeText = '($_countdownTime)重新获取';
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
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '修改手机号', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
          child: Column(
            children: [
              AccountWidgets.changeMobileHeaderView(_mobile),
              SizedBox(height: 10),
              AccountWidgets.changeMobileView(
                  _mobileTextController, _codeText, _getCodeAction),
              SizedBox(height: 1),
              AccountWidgets.changeMobileCodeView(_codeTextController),
              SizedBox(height: 20),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _changeAction,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _isLogin
                        ? XCColors.bannerSelectedColor
                        : XCColors.changeMobileButtonColor,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Text(
                    '确认',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
