import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/info/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../entity.dart';

class MineInfoDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MineInfoDetailScreenState();
}

class MineInfoDetailScreenState extends State<MineInfoDetailScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _idCardTextController = TextEditingController();
  TextEditingController _mobileTextController = TextEditingController();
  TextEditingController _codeTextController = TextEditingController();
  String _codeText = '获取验证码';
  bool _isSave = false;
  Timer? _timer;
  int _countdownTime = 60;
  InfoEntity _entity = InfoEntity();

  @override
  void dispose() {
    _nameTextController.dispose();
    _idCardTextController.dispose();
    _mobileTextController.dispose();
    _codeTextController.dispose();
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();

    _nameTextController.addListener(() {
      setState(() {
        _isSave = _checkSave();
      });
    });

    _idCardTextController.addListener(() {
      setState(() {
        _isSave = _checkSave();
      });
    });

    _mobileTextController.addListener(() {
      setState(() {
        _isSave = _checkSave();
      });
    });

    _codeTextController.addListener(() {
      setState(() {
        _isSave = _checkSave();
      });
    });
  }

  void _init() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.userInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = InfoEntity.fromJson(http.data);
        _nameTextController.text = _entity.realName ?? '';
        _idCardTextController.text = _entity.idCardNumber ?? '';
        _mobileTextController.text = _entity.phone ?? '';
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  bool _checkSave() {
    return _nameTextController.text.isNotEmpty &&
        _idCardTextController.text.isNotEmpty &&
        _mobileTextController.text.isNotEmpty &&
        _codeTextController.text.isNotEmpty;
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

  // 保存信息
  void _saveInfo() async {
    if (!_isSave) return;
    FocusScope.of(context).requestFocus(FocusNode());

    if (!Tool.isChinaPhoneLegal(_mobileTextController.text)) {
      return ToastHud.show(context, '请输入正确的手机号');
    }

    Map<String, String> params = Map();
    params['idCardNumber'] = _idCardTextController.text;
    params['realName'] = _nameTextController.text;
    params['phone'] = _mobileTextController.text;
    params['code'] = _codeTextController.text;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.saveInfo, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '保存成功');
      Navigator.pop(context);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '完善会员信息', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            MineInfoWidgets.infoDetailItemView(context, '真实姓名', '请输入本人真实姓名',
                _nameTextController, TextInputType.text),
            MineInfoWidgets.infoDetailItemView(context, '身份证号码', '请输入本人身份证件号码',
                _idCardTextController, TextInputType.number),
            MineInfoWidgets.infoDetailItemView(context, '手机号', '请输入手机号',
                _mobileTextController, TextInputType.phone),
            MineInfoWidgets.infoDetailWithCodeItemView(
                context,
                '短信验证码',
                '输入验证码',
                _codeTextController,
                TextInputType.number,
                _codeText,
                _getCodeAction),
            SizedBox(height: 120),
            CommonWidgets.checkButton('保存', _isSave, _saveInfo)
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
