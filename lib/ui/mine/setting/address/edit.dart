import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/setting/address/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressEntity entity;

  EditAddressScreen(this.entity);

  @override
  State<StatefulWidget> createState() => EditAddressScreenState();
}

class EditAddressScreenState extends State<EditAddressScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _mobileTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  String _province = '';
  String _city = '';
  List<dynamic> _provinceList = <dynamic>[];

  @override
  void dispose() {
    _mobileTextController.dispose();
    _nameTextController.dispose();
    _addressTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _nameTextController.text = widget.entity.name;
    _mobileTextController.text = widget.entity.phoneNumber;
    _addressTextController.text = widget.entity.detailAddress;
    _province = widget.entity.province;
    _city = widget.entity.city;

    Future.delayed(Duration.zero, () {
      initAddress();
    });
  }

  void initAddress() async {
    var address = await DefaultAssetBundle.of(context)
        .loadString('assets/resources/address.json');
    var data = json.decode(address);
    data.forEach((element) {
      Map<String, dynamic> province = Map();
      List<dynamic> cityList = <dynamic>[];
      element['cities'].forEach((city) {
        Map<String, dynamic> cityMap = Map();
        List<String> districtList = <String>[];
        city['district'].forEach((district) {
          districtList.add(district['area']);
        });
        cityMap[city['city']] = districtList;
        cityList.add(cityMap);
      });
      province[element['province']] = cityList;
      _provinceList.add(province);
    });
  }

  void _saveInfo() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_nameTextController.text.isEmpty)
      return ToastHud.show(context, '收件人不能为空');
    if (_mobileTextController.text.isEmpty)
      return ToastHud.show(context, '手机号不能为空');
    if (_province.isEmpty) return ToastHud.show(context, '请选择省份');
    if (_city.isEmpty) return ToastHud.show(context, '请选择市区');
    if (_addressTextController.text.isEmpty)
      return ToastHud.show(context, '详细地址不能为空');

    Map<String, dynamic> params = Map();
    params['city'] = _city;
    params['detailAddress'] = _addressTextController.text;
    params['name'] = _nameTextController.text;
    params['phoneNumber'] = _mobileTextController.text;
    params['province'] = _province;

    ToastHud.loading(context);
    var http = await HttpManager.post(
        DsApi.addressChange + widget.entity.id.toString(), params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '修改成功!');
      Navigator.pop(context, 1);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _tapAction(int index) {
    FocusScope.of(context).requestFocus(FocusNode());
    if (index == 1) {
      List<dynamic> data = [];
      _provinceList.forEach((element) {
        data.addAll(element.keys);
      });
      _selectedAddress(index, data);
    } else {
      if (_province.isEmpty) return ToastHud.show(context, '请选择省份');
      List<dynamic> data = [];
      _provinceList.forEach((element) {
        List<dynamic> keys = [];
        keys.addAll(element.keys);
        if (keys.contains(_province)) {
          element[_province].forEach((e) {
            data.addAll(e.keys);
          });
        }
      });
      _selectedAddress(index, data);
    }
  }

  void _selectedAddress(int type, List<dynamic> data) {
    Picker picker = Picker(
      height: 200,
      itemExtent: 35,
      adapter: PickerDataAdapter<String>(pickerdata: data),
      changeToFirst: true,
      columnPadding: const EdgeInsets.all(8.0),
      textAlign: TextAlign.left,
      cancelText: '取消',
      confirmText: '确定',
      cancelTextStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
      confirmTextStyle: TextStyle(fontSize: 16, color: XCColors.mainTextColor),
      textStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
      selectedTextStyle: TextStyle(fontSize: 18, color: XCColors.mainTextColor),
      onConfirm: (Picker picker, List value) {
        setState(
          () {
            if (type == 1) {
              String province = picker.getSelectedValues()[0];
              if (_province != province) {
                _province = province;
                _city = '';
              }
            } else {
              _city = picker.getSelectedValues()[0];
            }
          },
        );
      },
    );
    picker.showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '编辑地址', () {
        Navigator.pop(context);
      }),
      body: Column(
        children: [
          SizedBox(height: 10),
          AddressWidgets.createAddressItem(
            context,
            '收件人',
            _nameTextController,
            TextInputType.text,
          ),
          AddressWidgets.createAddressItem(
            context,
            '手机号',
            _mobileTextController,
            TextInputType.phone,
          ),
          AddressWidgets.createAddressChooseItem(
            context,
            1,
            _province,
            _tapAction,
          ),
          AddressWidgets.createAddressChooseItem(
            context,
            2,
            _city,
            _tapAction,
          ),
          AddressWidgets.createAddressDetailItem(
            context,
            _addressTextController,
          ),
          SizedBox(height: 20),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _saveInfo,
            child: Container(
              height: 50,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: XCColors.bannerSelectedColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: Text(
                '保存',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
