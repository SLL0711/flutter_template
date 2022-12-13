import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class DetailOrderInsuranceView extends StatefulWidget {
  final double guaranteeAmount;

  DetailOrderInsuranceView(this.guaranteeAmount);

  @override
  State<StatefulWidget> createState() => DetailOrderInsuranceViewState();
}

class DetailOrderInsuranceViewState extends State<DetailOrderInsuranceView>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _idCardTextEditingController = TextEditingController();
  TextEditingController _mobileTextEditingController = TextEditingController();
  bool _isAgree = true;
  bool _isSubmit = false;

  @override
  void dispose() {
    _nameTextEditingController.dispose();
    _idCardTextEditingController.dispose();
    _mobileTextEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nameTextEditingController.addListener(() {
      setState(() {
        _isSubmit = _nameTextEditingController.text.isNotEmpty &&
            _idCardTextEditingController.text.isNotEmpty &&
            _mobileTextEditingController.text.isNotEmpty &&
            _isAgree;
      });
    });

    _idCardTextEditingController.addListener(() {
      setState(() {
        _isSubmit = _nameTextEditingController.text.isNotEmpty &&
            _idCardTextEditingController.text.isNotEmpty &&
            _mobileTextEditingController.text.isNotEmpty &&
            _isAgree;
      });
    });

    _mobileTextEditingController.addListener(() {
      setState(() {
        _isSubmit = _nameTextEditingController.text.isNotEmpty &&
            _idCardTextEditingController.text.isNotEmpty &&
            _mobileTextEditingController.text.isNotEmpty &&
            _isAgree;
      });
    });
  }

  void _pushInfoAction() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _changeAgreeAction() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _isAgree = !_isAgree;
      _isSubmit = _nameTextEditingController.text.isNotEmpty &&
          _idCardTextEditingController.text.isNotEmpty &&
          _mobileTextEditingController.text.isNotEmpty &&
          _isAgree;
    });
  }

  void _pushAgreeAction() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _submitAction() {
    if (!_isSubmit) return;
    FocusScope.of(context).requestFocus(FocusNode());

    OrderInsuranceEntity entity = OrderInsuranceEntity();
    entity.name = _nameTextEditingController.text;
    entity.mobile = _mobileTextEditingController.text;
    entity.idCard = _idCardTextEditingController.text;

    Navigator.pop(context, entity);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '填写保单', () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                OrderWidgets.insuranceInfo(context, _pushInfoAction),
                SizedBox(height: 10),
                OrderWidgets.insurancePriceInfo(
                    context, widget.guaranteeAmount.toString()),
                SizedBox(height: 1),
                OrderWidgets.insuranceEditInfo(
                    context, '被保人姓名', '请输入真实姓名', _nameTextEditingController),
                SizedBox(height: 1),
                OrderWidgets.insuranceEditInfo(context, '身份证号', '请输入被保人的身份证',
                    _idCardTextEditingController),
                SizedBox(height: 1),
                OrderWidgets.insuranceEditInfo(
                    context, '手机号', '请输入手机号', _mobileTextEditingController),
                SizedBox(height: 1),
                OrderWidgets.insuranceAgreeInfo(
                    context, _isAgree, _changeAgreeAction, _pushAgreeAction),
                SizedBox(height: 35),
                CommonWidgets.checkButton('提交', _isSubmit, _submitAction)
              ],
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
