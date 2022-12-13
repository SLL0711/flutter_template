import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/info/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/info/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/info/nickname.dart';
import 'package:flutter_medical_beauty/ui/mine/info/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../event_center.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MineInfoScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MineInfoScreenState();
}

class MineInfoScreenState extends State<MineInfoScreen>
    with AutomaticKeepAliveClientMixin {
  InfoEntity _entity = InfoEntity();
  List _sexList = [
    {'sex': '男', 'gender': 1},
    {'sex': '女', 'gender': 2},
  ];
  List<SexEntity> _sexEntityList = <SexEntity>[];
  List<dynamic> _provinceList = <dynamic>[];

  @override
  void initState() {
    super.initState();

    // 筛选初始化
    _sexEntityList = _sexList.map((value) {
      return SexEntity.fromJson(value);
    }).toList();

    Future.delayed(Duration.zero, () {
      init();
      initAddress();
    });
  }

  void init() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.userInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = InfoEntity.fromJson(http.data);
        _sexEntityList.forEach((element) {
          if (element.gender == _entity.gender) {
            element.isSelected = true;
          }
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
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

  void uploadImage(XFile file) async {
    Map<String, String> param = Map<String, String>();
    param['key'] = file.name;
    ToastHud.loading(context);
    // 获取上传图片签名
    var http = await HttpManager.get(DsApi.ocsSign, context, params: param);
    if (http.code == 200) {
      COSSignEntity _cosSignEntity = COSSignEntity.fromJson(http.data);
      Map<String, String> headers = Map<String, String>();
      headers['Authorization'] = _cosSignEntity.sign;
      headers['x-cos-security-token'] = _cosSignEntity.sessionToken;
      List<int> body = await file.readAsBytes();
      String url = _cosSignEntity.baseUrl + "/" + _cosSignEntity.key;
      HttpItem res = await HttpManager.uploadImage(url, headers, body);
      debugPrint('uploadImage:  ' + res.data);
      if (res.code == 200) {
        _changeInfo("icon", 0, res.data, 0);
      } else {
        ToastHud.show(context, res.message!);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
    ToastHud.dismiss();
  }

  void _tapType(int type) {
    if (type == 0) {
      MineInfoDialog.showAvatarDialog(context, _selectAvatar);
    } else if (type == 1) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  ChangeNicknameScreen(_entity.nickName!))).then((value) {
        if (value == null) return;
        setState(() {
          _entity.nickName = value;
        });
      });
    } else if (type == 2) {
      MineInfoDialog.showSexDialog(context, _sexEntityList, _selectSex);
    } else if (type == 3) {
      _selectBirthday();
    } else if (type == 4) {
      _selectCity();
    }
  }

  void _selectBirthday() {
    DateTime dateTime = DateTime.now();
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
            cancelStyle:
                TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
            doneStyle: TextStyle(fontSize: 16, color: XCColors.mainTextColor)),
        showTitleActions: true,
        maxTime: DateTime(dateTime.year, dateTime.month, dateTime.day),
        onConfirm: (date) {
      List<String> dates = date.toString().split(' ');
      String birthday = dates.first;
      _changeInfo('birthday', 0, birthday, 2);
    }, currentTime: dateTime, locale: LocaleType.zh);
  }

  void _selectCity() async {
    Picker picker = Picker(
        height: 200,
        itemExtent: 35,
        adapter: PickerDataAdapter<String>(pickerdata: _provinceList),
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
          String city = picker.getSelectedValues()[1];
          print(picker.getSelectedValues()[0] +
              picker.getSelectedValues()[1] +
              picker.getSelectedValues()[2]);
          _changeInfo('city', 0, city, 3);
        });
    picker.showModal(context);
  }

  void _selectAvatar(int type) async {
    var file;
    if (type == 1) {
      bool isCamera = await requestCameraPermission();
      if (isCamera) {
        file = await ImagePicker().pickImage(source: ImageSource.camera);
      } else {
        ToastHud.show(context, '请打开相机权限');
      }
    } else {
      file = await ImagePicker().pickImage(source: ImageSource.gallery);
    }
    //上传图片
    uploadImage(file);
  }

  /// 申请相机权限
  /// 授予相机权限返回true， 否则返回false
  Future<bool> requestCameraPermission() async {
    //获取当前的权限
    var status = await Permission.camera.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.camera.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _selectSex(int gender) {
    _changeInfo('gender', gender, '', 1);
  }

  // 保存信息
  void _changeInfo(String key, int value, String birthday, int type) async {
    Map<String, String> params = Map();
    if (type == 1) {
      params[key] = '$value';
    } else {
      params[key] = birthday;
    }
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.changeInfo, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '修改成功');
      if (type == 0) {
        setState(() {
          _entity.icon = birthday;
        });
      } else if (type == 1) {
        _sexEntityList.forEach((element) {
          element.isSelected = element.gender == value;
        });
        setState(() {
          _entity.gender = value;
        });
      } else if (type == 2) {
        setState(() {
          _entity.birthday = birthday;
        });
      } else if (type == 3) {
        setState(() {
          _entity.city = birthday;
        });
      }
      EventCenter.defaultCenter().fire(RefreshMineEvent('updateInfo'));
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  // 完善信息
  void _editInfo() {
    NavigatorUtil.pushPage(context, MineInfoDetailScreen());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    String sex = _entity.gender == 1 ? '男' : (_entity.gender == 2 ? '女' : '未知');

    String birthday = '';
    if (_entity.birthday!.contains('T')) {
      DateTime beijingTime =
          DateTime.parse("${_entity.birthday!.substring(0, 19)}-0800");
      birthday = formatDate(beijingTime, [yyyy, '-', mm, '-', dd]);
    } else {
      birthday = _entity.birthday!;
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: CityWidgets.cityAppBar(context, '个人资料', () {
        EventCenter.defaultCenter().fire(RefreshMineEvent(''));
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 1, color: XCColors.homeDividerColor),
            MineInfoWidgets.infoHeaderView(context, _entity.icon, _tapType),
            MineInfoWidgets.infoItemView(
                context, '昵称', '${_entity.nickName}', 1, _tapType),
            MineInfoWidgets.infoItemView(context, '性别', sex, 2, _tapType),
            MineInfoWidgets.infoItemView(context, '年龄', birthday, 3, _tapType),
            MineInfoWidgets.infoItemView(
                context, '地区', '${_entity.city}', 4, _tapType),
            SizedBox(height: 40),
            CommonWidgets.mainButton('完善会员信息', _editInfo)
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
