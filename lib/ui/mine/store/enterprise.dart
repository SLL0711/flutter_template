/*
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/info/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/store/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/store/review.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../colors.dart';
import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';
import '../../../tool.dart';
import '../entity.dart';
import 'widgets.dart';

class StoreEnterpriseScreen extends StatefulWidget {
  final Map<String, dynamic> baseData;
  final ApplyInfoEntity applyInfo;

  StoreEnterpriseScreen(this.baseData, this.applyInfo);

  @override
  State<StatefulWidget> createState() => StoreEnterpriseScreenState();
}

class StoreEnterpriseScreenState extends State<StoreEnterpriseScreen>
    with AutomaticKeepAliveClientMixin {
  // 企业证书照片
  String _businessLicenseUrl = '',
      _brandAuthImageUrl = '',
      _tradeMarkImageUrl = '';

  // 身份证照片
  String _idCardFrontImageUrl = '', _idCardBackImageUrl = '';

  // 照片位置
  int _imagePosition = 0;

  // 营业执照注册号
  TextEditingController _businessController = TextEditingController();

  // 公司名称
  TextEditingController _companyNameController = TextEditingController();

  // 注册资金
  TextEditingController _registerMoneyController = TextEditingController();

  // 经营范围
  TextEditingController _manageController = TextEditingController();

  // 公司网址
  TextEditingController _webSiteController = TextEditingController();

  // 旗下品牌
  TextEditingController _brandController = TextEditingController();

  // 法人姓名
  TextEditingController _legalNameController = TextEditingController();

  // 法人手机号
  TextEditingController _legalPhoneController = TextEditingController();

  // 法人地址
  TextEditingController _legalAddressController = TextEditingController();

  // 银行卡真实姓名
  TextEditingController _realNameController = TextEditingController();

  // 银行卡身份证号
  TextEditingController _identifyController = TextEditingController();

  // 银行卡卡号
  TextEditingController _bankCardController = TextEditingController();

  // 银行卡手机号
  TextEditingController _phoneController = TextEditingController();

  // 微信账号
  TextEditingController _weChatController = TextEditingController();

  // 支付宝账号
  TextEditingController _aliPayController = TextEditingController();

  // 地址数据
  String _provinceName = '上海市', _cityName = '徐汇区', _areaName = '徐家汇街道';
  int _provinceCode = 310000, _cityCode = 310104, _areaCode = 310104003;
  Map<int, dynamic> _areaCache = Map();

  // 是否同意协议
  bool _isAgree = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _initLocationAddress);
    super.initState();
  }

  /// 初始化定位地址
  void _initLocationAddress() async {
    //判断是否有已有申请数据
    if (widget.applyInfo.id != 0) {
      _initApplyInfo();
    }
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

  /// 初始化申请数据
  void _initApplyInfo() {
    ApplyCompanyEntity entity = widget.applyInfo.shopApplyCompany;
    _businessController.text = entity.companyCode;
    _companyNameController.text = entity.companyName;
    _registerMoneyController.text = '${entity.companyRegisterMoney}';
    _manageController.text = entity.companyManage;
    _webSiteController.text = entity.webSite;
    _brandController.text = entity.companyBrand;
    _businessLicenseUrl = entity.businessLicenseUrl;
    _brandAuthImageUrl = entity.brandAuthImageUrl;
    _tradeMarkImageUrl = entity.tradeMarkImageUrl;
    _legalNameController.text = entity.legalPersonName;
    _legalPhoneController.text = entity.egalPersonPhone;
    _provinceCode = entity.provinceCode.isNotEmpty
        ? int.parse(entity.provinceCode)
        : _provinceCode;
    _cityCode =
        entity.cityCode.isNotEmpty ? int.parse(entity.cityCode) : _cityCode;
    _areaCode =
        entity.areaCode.isNotEmpty ? int.parse(entity.areaCode) : _areaCode;
    _legalAddressController.text = entity.address;
    _idCardFrontImageUrl = entity.idCardFrontImageUrl;
    _idCardBackImageUrl = entity.idCardBackImageUrl;
    _realNameController.text = entity.realName;
    _identifyController.text = entity.idCardNumber;
    _bankCardController.text = entity.bankCardNumber;
    _phoneController.text = entity.phone;
    _weChatController.text = entity.wechatAccount;
    _aliPayController.text = entity.alipayAccount;
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
          if (_imagePosition == 4) {
            _idCardBackImageUrl = res.data;
          } else if (_imagePosition == 3) {
            _idCardFrontImageUrl = res.data;
          } else if (_imagePosition == 2) {
            _tradeMarkImageUrl = res.data;
          } else if (_imagePosition == 1) {
            _brandAuthImageUrl = res.data;
          } else {
            _businessLicenseUrl = res.data;
          }
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

  /// 申请入驻
  void _applySettle() async {
    if (!_isAgree) {
      ToastHud.show(context, "请仔细阅读并同意协议");
      return;
    }
    String business = _businessController.text;
    String companyName = _companyNameController.text;
    String registerMoney = _registerMoneyController.text;
    String manage = _manageController.text;
    String webSite = _webSiteController.text;
    String brand = _brandController.text;
    String legalName = _legalNameController.text;
    String legalPhone = _legalPhoneController.text;
    String address = _legalAddressController.text;
    // 提款账户数据
    String realName = _realNameController.text;
    String identity = _identifyController.text;
    String bankCard = _bankCardController.text;
    String phone = _phoneController.text;
    String weChat = _weChatController.text;
    String aliPay = _aliPayController.text;
    // 企业参数
    Map<String, dynamic> params = Map();
    params['address'] = address;
    params['alipayAccount'] = aliPay;
    params['areaCode'] = _areaCode;
    params['bankCardNumber'] = bankCard;
    params['brandAuthImageUrl'] = _brandAuthImageUrl;
    params['businessLicenseUrl'] = _businessLicenseUrl;
    params['cityCode'] = _cityCode;
    params['companyBrand'] = brand;
    params['companyCode'] = business;
    params['companyManage'] = manage;
    params['companyName'] = companyName;
    params['companyRegisterMoney'] = registerMoney;
    params['egalPersonPhone'] = legalPhone;
    params['idCardBackImageUrl'] = _idCardBackImageUrl;
    params['idCardFrontImageUrl'] = _idCardFrontImageUrl;
    params['idCardNumber'] = identity;
    params['legalPersonName'] = legalName;
    params['phone'] = phone;
    params['provinceCode'] = _provinceCode;
    params['realName'] = realName;
    params['tradeMarkImageUrl'] = _tradeMarkImageUrl;
    params['webSite'] = webSite;
    params['wechatAccount'] = weChat;
    // 请求的body
    Map<String, dynamic> body = widget.baseData;
    body['shopApplyCompany'] = params;
    // 请求接口提交
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.joinApply, body, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      // 申请成功
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => StoreReviewScreen(false),
        ),
      );
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

            /// 企业
            StoreWidgets.storeEnterpriseHeaderView(
                context,
                _businessController,
                _companyNameController,
                _registerMoneyController,
                _manageController,
                _webSiteController,
                _brandController,
                _businessLicenseUrl,
                _brandAuthImageUrl,
                _tradeMarkImageUrl, (position) {
              _imagePosition = position;
              MineInfoDialog.showAvatarDialog(context, _selectImage);
            }),
            SizedBox(height: 10),

            /// 法人
            StoreWidgets.storeEnterprisePersonView(
                context,
                _legalNameController,
                _legalPhoneController,
                _legalAddressController,
                _provinceName,
                _cityName,
                _areaName,
                _selectArea,
                _idCardFrontImageUrl,
                _idCardBackImageUrl, (position) {
              _imagePosition = position;
              MineInfoDialog.showAvatarDialog(context, _selectImage);
            }),
            SizedBox(height: 10),

            /// 提款信息
            StoreWidgets.storePersonBankView(
                context,
                _realNameController,
                _identifyController,
                _bankCardController,
                _phoneController,
                _weChatController,
                _aliPayController,
                isEnterprise: true),
            SizedBox(height: 10),

            /// 认证规则
            StoreWidgets.storePersonRuleView(
              context,
              _isAgree,
              () {
                setState(() {
                  _isAgree = !_isAgree;
                });
              },
              _applySettle,
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
