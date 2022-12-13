/*
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/info/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/store/enterprise.dart';
import 'package:flutter_medical_beauty/ui/mine/store/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/store/person.dart';
import 'package:flutter_medical_beauty/ui/mine/store/review.dart';
import 'package:flutter_medical_beauty/ui/mine/store/widgets.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';
import '../entity.dart';

class StoreScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StoreScreenState();
}

class StoreScreenState extends State<StoreScreen>
    with AutomaticKeepAliveClientMixin {
  // 店铺类型
  int _applyType = 0;

  // 店铺名称
  TextEditingController _nameController = TextEditingController();

  // 店铺描述
  TextEditingController _describeController = TextEditingController();

  // 店铺地址
  TextEditingController _linkController = TextEditingController();

  // LOGO地址
  String _logoUrl = '';

  // 法人真实姓名
  TextEditingController _realNameController = TextEditingController();

  // 法人身份证
  TextEditingController _identifyController = TextEditingController();

  // 法人手机号
  TextEditingController _phoneController = TextEditingController();

  // 法人邮箱
  TextEditingController _emailController = TextEditingController();

  // 地址数据
  String _provinceName = '上海市', _cityName = '徐汇区', _areaName = '徐家汇街道';
  int _provinceCode = 310000, _cityCode = 310104, _areaCode = 310104003;
  Map<int, dynamic> _areaCache = Map();

  // 入驻信息
  ApplyInfoEntity _applyInfo = ApplyInfoEntity();

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  Future<void> _init() async {
    //====
    _initLocationAddress();
    //====
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.applyInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data is Map<String, dynamic>) {
        setState(() {
          _applyInfo = ApplyInfoEntity.fromJson(http.data);
          // 根据状态跳转界面
          if (_applyInfo.auditStatus < 2) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    StoreReviewScreen(_applyInfo.auditStatus == 1),
              ),
            );
          }
          // 回选数据
          _applyType = _applyInfo.applyType;
          _nameController.text = _applyInfo.shopName;
          _describeController.text = _applyInfo.shopDescription;
          _linkController.text = _applyInfo.taoBaoAddress;
          _logoUrl = _applyInfo.shopLogo;
          if (_applyType == 0) {
            ApplyPersonEntity entity = _applyInfo.shopApplyMember;
            _realNameController.text = entity.realName;
            _identifyController.text = entity.idCardNumber;
            _phoneController.text = entity.phone;
            _emailController.text = entity.email;
            _provinceCode = int.parse(_applyInfo.provinceCode);
            _cityCode = int.parse(_applyInfo.cityCode);
            _areaCode = int.parse(_applyInfo.areaCode);
          }
        });
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 初始化定位地址
  void _initLocationAddress() async {
    String province = await Tool.getString('province');
    String city = await Tool.getString('city');
    String district = await Tool.getString('district');
    int provinceCode = int.parse(await Tool.getString('provinceCode'));
    int cityCode = int.parse(await Tool.getString('cityCode'));
    int districtCode = int.parse(await Tool.getString('districtCode'));
    if (province.isNotEmpty &&
        city.isNotEmpty &&
        district.isNotEmpty &&
        provinceCode != 0 &&
        cityCode != 0 &&
        districtCode != 0) {
      setState(() {
        _provinceName = province;
        _provinceCode = provinceCode;
        _cityName = city;
        _cityCode = cityCode;
        _areaName = district;
        _areaCode = districtCode;
      });
    }
  }

  /// 选择LOGO
  void _selectLogo() {
    MineInfoDialog.showAvatarDialog(context, _selectImage);
  }

  ///选择图片
  void _selectImage(int type) async {
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
    uploadImage(file);
  }

  /// 上传图片
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
        setState(() {
          _logoUrl = res.data;
        });
      } else {
        ToastHud.show(context, res.message!);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
    ToastHud.dismiss();
  }

  /// 申请相机权限
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

  /// 选择城市
  void _selectArea(int level) {
    int id = 0;
    if (level == 2) {
      id = _cityCode;
    } else if (level == 1) {
      id = _provinceCode;
    }
    List<HomeAddressEntity> list = _areaCache[id] ?? [];
    if (list.isNotEmpty) {
      //数据处理
      List<String> areaList = <String>[];
      list.forEach((entity) {
        areaList.add(entity.fullname);
      });
      _showPicker(level, areaList);
    } else {
      _requestArea(id, level);
    }
  }

  void _showPicker(int level, List<String> list) {
    Picker picker = Picker(
      height: 200,
      itemExtent: 35,
      adapter: PickerDataAdapter<String>(pickerdata: list),
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
        setState(() {
          if (level == 0) {
            List<HomeAddressEntity> list = _areaCache[0];
            HomeAddressEntity entity = list[value[0]];
            _provinceName = entity.fullname;
            _provinceCode = entity.id;
          } else if (level == 1) {
            List<HomeAddressEntity> list = _areaCache[_provinceCode];
            HomeAddressEntity entity = list[value[0]];
            _cityName = entity.fullname;
            _cityCode = entity.id;
          } else {
            List<HomeAddressEntity> list = _areaCache[_cityCode];
            HomeAddressEntity entity = list[value[0]];
            _areaName = entity.fullname;
            _areaCode = entity.id;
          }
        });
        debugPrint('$picker $value');
      },
    );
    picker.showModal(context);
  }

  void _requestArea(int parentId, int level) async {
    Map<String, String> params = Map();
    params['parentId'] = parentId.toString();
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.area, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      //获取地址数据
      List<String> areaList = <String>[];
      List<HomeAddressEntity> list = <HomeAddressEntity>[];
      http.data.forEach((element) {
        HomeAddressEntity entity = HomeAddressEntity.fromJson(element);
        list.add(entity);
        areaList.add(entity.fullname);
      });
      _areaCache[parentId] = list;
      _showPicker(level, areaList);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '商家入驻', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),

            ///店铺信息
            StoreWidgets.storeInfo(
                context,
                _applyType,
                _nameController,
                _describeController,
                _linkController,
                _logoUrl,
                _selectLogo, (type) {
              setState(() {
                _applyType = type;
              });
            }),
            _applyType == 1 ? Container() : SizedBox(height: 10),

            /// 个人类型才有----法人信息
            _applyType == 1
                ? Container()
                : StoreWidgets.personInfo(
                    context,
                    _realNameController,
                    _identifyController,
                    _phoneController,
                    _emailController,
                    _provinceName,
                    _cityName,
                    _areaName,
                    _selectArea,
                  ),

            ///  操作按钮
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                String shopName = _nameController.text;
                String shopDescription = _describeController.text;
                String taoBaoAddress = _linkController.text;
                String realName = _realNameController.text;
                String identify = _identifyController.text;
                String phone = _phoneController.text;
                String email = _emailController.text;
                // 数据校验
                if (shopName.isEmpty) {
                  ToastHud.show(context, "店铺名称不能空");
                  return;
                }
                if (shopDescription.isEmpty) {
                  ToastHud.show(context, "店铺描述不能为空");
                  return;
                }
                if (_logoUrl.isEmpty) {
                  ToastHud.show(context, "店铺LOGO不能空");
                  return;
                }
                if (_applyType == 0) {
                  if (realName.isEmpty) {
                    ToastHud.show(context, "法人真实姓名不能空");
                    return;
                  }
                  if (identify.isEmpty) {
                    ToastHud.show(context, "法人身份证不能空");
                    return;
                  }
                  if (phone.isEmpty) {
                    ToastHud.show(context, "手机号码不能空");
                    return;
                  }
                  if (email.isEmpty) {
                    ToastHud.show(context, "邮箱账户不能空");
                    return;
                  }
                }
                Map<String, dynamic> params = Map();
                params['applyType'] = _applyType;
                params['shopName'] = shopName;
                params['shopDescription'] = shopDescription;
                params['taoBaoAddress'] = taoBaoAddress;
                params['shopLogo'] = _logoUrl;
                // 法人信息
                params['realName'] = realName;
                params['idCardNumber'] = identify;
                params['phone'] = phone;
                params['email'] = email;
                params['_provinceCode'] = _provinceCode;
                params['_cityCode'] = _cityCode;
                params['_areaCode'] = _areaCode;
                if (_applyInfo.id > 0) {
                  params['id'] = _applyInfo.id;
                }
                // 下一步
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => _applyType == 0
                        ? StorePersonScreen(params, _applyInfo)
                        : StoreEnterpriseScreen(params, _applyInfo),
                  ),
                );
              },
              child: Container(
                height: 50,
                margin: EdgeInsets.all(15),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Text(
                  '下一步',
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
*/
