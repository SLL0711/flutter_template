import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/mine/invoice/entity.dart';

import '../../../../api.dart';
import '../../../../colors.dart';
import '../../../../http.dart';
import '../../../../toast.dart';
import '../widgets.dart';

class InvoiceEnterpriseScreen extends StatefulWidget {
  final int orderId;

  InvoiceEnterpriseScreen(this.orderId);

  @override
  State<StatefulWidget> createState() => InvoiceEnterpriseScreenState();
}

class InvoiceEnterpriseScreenState extends State<InvoiceEnterpriseScreen>
    with AutomaticKeepAliveClientMixin {
  ///变量
  TextEditingController _companyController = new TextEditingController();
  TextEditingController _codeController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  InvoiceEntity _entity = new InvoiceEntity();

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    Map<String, dynamic> params = Map();
    params['type'] = 1;

    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.myInvoice,
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data != null) {
        setState(() {
          _entity = InvoiceEntity.fromJson(http.data);
          _companyController.text = _entity.companyName;
          _codeController.text = _entity.code;
          _phoneController.text = _entity.mobile;
          _emailController.text = _entity.email;
        });
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _saveInvoice() async {
    String companyName = _companyController.text;
    String code = _codeController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    if (companyName.isEmpty) {
      ToastHud.show(context, '请填写单位名称');
      return;
    }
    if (code.isEmpty) {
      ToastHud.show(context, '请填写纳税人识别号');
      return;
    }
    if (phone.isEmpty) {
      ToastHud.show(context, '请输入联系人手机号');
      return;
    }
    if (!Tool.isChinaPhoneLegal(phone)) {
      ToastHud.show(context, '请输入正确的手机号');
      return;
    }

    /// 没有修改直接使用的不用调用接口
    if (_entity.companyName == companyName &&
        _entity.code == code &&
        _entity.mobile == phone &&
        _entity.email == email) {
      _applyInvoice();
      return;
    }

    Map<String, dynamic> params = Map();
    params['type'] = 1;
    params['code'] = code;
    params['companyName'] = companyName;
    params['mobile'] = phone;
    params['email'] = email;

    ToastHud.loading(context);
    var http;
    if (_entity.id == 0) {
      http = await HttpManager.post(
        DsApi.addInvoice,
        params,
        context,
      );
    } else {
      params['id'] = _entity.id;
      http = await HttpManager.put(
        DsApi.updateInvoice,
        params,
        context,
      );
    }
    ToastHud.dismiss();
    if (http.code == 200) {
      if (widget.orderId != 0) {
        _applyInvoice();
      } else {
        ToastHud.show(context, '保存成功');
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _applyInvoice() async {
    String companyName = _companyController.text;
    String code = _codeController.text;
    String phone = _phoneController.text;
    String email = _emailController.text;
    Map<String, dynamic> params = Map();
    params['type'] = 0;
    params['companyName'] = companyName;
    params['code'] = code;
    params['mobile'] = phone;
    params['email'] = email;

    ToastHud.loading(context);
    var http = await HttpManager.post(
      DsApi.applyInvoice + widget.orderId.toString(),
      params,
      context,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '申请成功');
      Navigator.pop(context);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              color: XCColors.homeDividerColor,
            ),
            Container(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
              child: Text(
                '请务必保证您填写信息的准确性，以保证您所开发票信息的准确性，此信息用户开具发票使用。',
                style: TextStyle(
                  fontSize: 12,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            InvoiceWidgets.otherItem(
              context,
              '单位名称',
              '请填写单位名称',
              _companyController,
            ),
            SizedBox(height: 10),
            InvoiceWidgets.otherItem(
              context,
              '识别号',
              '请填写纳税人识别号',
              _codeController,
            ),
            SizedBox(height: 10),
            InvoiceWidgets.otherItem(
              context,
              '手机号码',
              '请输入联系人手机号',
              _phoneController,
            ),
            SizedBox(height: 10),
            InvoiceWidgets.otherItem(
              context,
              '电子邮箱',
              '可不填',
              _emailController,
            ),
            SizedBox(height: 40),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                _saveInvoice();
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Text(
                  '保存',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
