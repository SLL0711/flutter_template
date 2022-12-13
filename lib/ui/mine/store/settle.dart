import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/login/article.dart';
import 'package:flutter_medical_beauty/ui/mine/info/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/store/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/store/review.dart';
import 'package:flutter_medical_beauty/ui/mine/store/widgets.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../api.dart';
import '../../../http.dart';
import '../../../navigator.dart';
import '../../../toast.dart';
import '../entity.dart';
import 'MultipleChoiceChipWidget.dart';

class SettleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettleScreenState();
}

class SettleScreenState extends State<SettleScreen>
    with AutomaticKeepAliveClientMixin {
  // 店铺类型
  int _applyType = 0, _gender = 1, _imagePosition = 0;

  // 店铺名称
  TextEditingController _nameController = TextEditingController();

  // 店铺描述
  TextEditingController _describeController = TextEditingController();

  // 手机号
  TextEditingController _phoneController = TextEditingController();

  // 微信账号
  TextEditingController _weChatController = TextEditingController();

  // 支付宝账号
  TextEditingController _aliPayController = TextEditingController();

  // 公司名称
  TextEditingController _companyController = TextEditingController();

  // 客户电话
  TextEditingController _telPhoneController = TextEditingController();

  // 对公账户名称
  TextEditingController _bankController = TextEditingController();

  // 开户银行
  TextEditingController _openBankController = TextEditingController();

  // 对公账号
  TextEditingController _accountController = TextEditingController();

  // 经营地址
  TextEditingController _addressController = TextEditingController();

  // 照片
  String _logoUrl = '',
      _faceUrl = '',
      _backUrl = '',
      _quantificationUrl = '',
      _businessUrl = '',
      _diagnosisUrl = '',
      _organizationUrl = '',
      _brandUrl = '',
      _tradeUrl = '';

  // 地址数据
  String _provinceName = '上海市', _cityName = '徐汇区', _areaName = '徐家汇街道';
  int _provinceCode = 310000, _cityCode = 310104, _areaCode = 310104003;
  Map<int, dynamic> _areaCache = Map();
  List<TagEntity> _tagList = <TagEntity>[];
  List<int> _selectTagList = <int>[];

  // 是否同意入驻协议
  bool _isAgree = false, _isGrounding = false;

  // 入驻信息
  ApplyInfoEntity _applyInfo = ApplyInfoEntity();

  @override
  void dispose() {
    _nameController.dispose();
    _describeController.dispose();
    _phoneController.dispose();
    _weChatController.dispose();
    _aliPayController.dispose();
    _companyController.dispose();
    _telPhoneController.dispose();
    _bankController.dispose();
    _openBankController.dispose();
    _accountController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  Future<void> _init() async {
    _isGrounding = await Tool.isGrounding();
    //====
    _initTagList();
    _initLocationAddress();
    //====
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.applyInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data is Map<String, dynamic>) {
        setState(
          () {
            _applyInfo = ApplyInfoEntity.fromJson(http.data);
            // 根据状态跳转界面 2 1 1
            if (_applyInfo.auditStatus == 2 ||
                (_applyInfo.auditStatus == 1 && _applyInfo.payStatus == 1)) {
              // 拒绝，或者入驻支付成功的情况
              // 回选数据
              _applyType = _applyInfo.applyType;
              _nameController.text = _applyInfo.shopName;
              _describeController.text = _applyInfo.shopDescription;
              _logoUrl = _applyInfo.shopLogo;
              _selectTagList.clear();
              if (_applyInfo.tagIds != '') {
                _applyInfo.tagIds.split(',').forEach((item) {
                  _selectTagList.add(int.parse(item));
                });
              }
              //
              _provinceCode = int.parse(_applyInfo.provinceCode);
              _cityCode = int.parse(_applyInfo.cityCode);
              _areaCode = int.parse(_applyInfo.areaCode);
              if (_applyType == 0) {
                ApplyPersonEntity entity = _applyInfo.shopApplyMember;
                _gender = entity.gender;
                _phoneController.text = entity.phone;
                _weChatController.text = entity.wechatAccount;
                _aliPayController.text = entity.alipayAccount;
                _faceUrl = entity.idCardFrontImageUrl;
                _backUrl = entity.idCardBackImageUrl;
                _quantificationUrl = entity.qualificationUrl;
                _businessUrl = entity.practiceUrl;
                _diagnosisUrl = entity.hairdressingQualificationUrl;
              } else {
                ApplyCompanyEntity entity = _applyInfo.shopApplyCompany;
                _companyController.text = entity.companyName;
                _phoneController.text = entity.phone;
                _telPhoneController.text = entity.servicePhone;
                _bankController.text = entity.accountName;
                _openBankController.text = entity.bankName;
                _accountController.text = entity.account;
                _weChatController.text = entity.wechatAccount;
                _aliPayController.text = entity.alipayAccount;
                _businessUrl = entity.businessLicenseUrl;
                _organizationUrl = entity.practiceLicenceUrl;
                _brandUrl = entity.brandAuthImageUrl;
                _tradeUrl = entity.tradeMarkImageUrl;
                _addressController.text = entity.address;
              }
              _isAgree = true;
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      StoreReviewScreen(_applyInfo.auditStatus == 1),
                ),
              );
            }
          },
        );
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 初始化标签数据
  void _initTagList() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.tagList, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          _tagList.add(TagEntity.fromJson(element));
        });
      });
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

  /// 选择图片
  void _selectImage(position) {
    _imagePosition = position;
    MineInfoDialog.showAvatarDialog(context, _pickImage);
  }

  ///选择图片
  void _pickImage(int type) async {
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
        setState(
          () {
            if (_imagePosition == 9) {
              _tradeUrl = res.data;
            } else if (_imagePosition == 8) {
              _brandUrl = res.data;
            } else if (_imagePosition == 7) {
              _organizationUrl = res.data;
            } else if (_imagePosition == 6) {
              _businessUrl = res.data;
            } else if (_imagePosition == 5) {
              _diagnosisUrl = res.data;
            } else if (_imagePosition == 4) {
              _businessUrl = res.data;
            } else if (_imagePosition == 3) {
              _quantificationUrl = res.data;
            } else if (_imagePosition == 2) {
              _backUrl = res.data;
            } else if (_imagePosition == 1) {
              _faceUrl = res.data;
            } else {
              _logoUrl = res.data;
            }
          },
        );
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

  /// 申请入驻
  void _applySettle() async {
    if (!_isAgree) {
      ToastHud.show(context, "请仔细阅读并同意协议");
      return;
    }
    String name = _nameController.text;
    String description = _describeController.text;
    String phone = _phoneController.text;
    String weChat = _weChatController.text;
    String aliPay = _aliPayController.text;
    String company = _companyController.text;
    String telPhone = _telPhoneController.text;
    String bank = _bankController.text;
    String openBank = _openBankController.text;
    String account = _accountController.text;
    String address = _addressController.text;
    // 数据校验
    if (name.isEmpty) {
      ToastHud.show(context, '名称不能为空');
      return;
    }
    if (description.isEmpty) {
      ToastHud.show(context, '简介不能为空');
      return;
    }
    if (_logoUrl.isEmpty) {
      ToastHud.show(context, 'LOGO不能为空');
      return;
    }
    if (phone.isEmpty) {
      ToastHud.show(context, '手机号码不能为空');
      return;
    }
    // 咨询师类型参数校验
    if (_applyType == 0 && _faceUrl.isEmpty) {
      ToastHud.show(context, '身份证正面照不能为空');
      return;
    }
    if (_applyType == 0 && _backUrl.isEmpty) {
      ToastHud.show(context, '身份证反面照不能为空');
      return;
    }
    if (!_isGrounding && _applyType == 0 && _quantificationUrl.isEmpty) {
      ToastHud.show(context, '咨询师资格证不能为空');
      return;
    }
    if (!_isGrounding && _applyType == 0 && _businessUrl.isEmpty) {
      ToastHud.show(context, '咨询师执业证不能为空');
      return;
    }
    if (!_isGrounding && _applyType == 0 && _diagnosisUrl.isEmpty) {
      ToastHud.show(context, '医疗美容主诊咨询师资格证不能为空');
      return;
    }
    // 商家类型参数校验
    if (_applyType == 1 && company.isEmpty) {
      ToastHud.show(context, '公司名称不能为空');
      return;
    }
    if (_applyType == 1 && telPhone.isEmpty) {
      ToastHud.show(context, '客户联系电话不能为空');
      return;
    }
    if (_applyType == 1 && _businessUrl.isEmpty) {
      ToastHud.show(context, '营业执照不能为空');
      return;
    }
    if (!_isGrounding && _applyType == 1 && _organizationUrl.isEmpty) {
      ToastHud.show(context, '医疗商家执业许可证不能为空');
      return;
    }
    if (!_isGrounding && _applyType == 1 && _brandUrl.isEmpty) {
      ToastHud.show(context, '品牌授权书不能为空');
      return;
    }
    if (!_isGrounding && _applyType == 1 && _tradeUrl.isEmpty) {
      ToastHud.show(context, '商标证书不能为空');
      return;
    }
    // 请求的body
    Map<String, dynamic> body = Map();
    Map<String, dynamic> params = Map();
    if (_applyInfo.id > 0) {
      body['id'] = _applyInfo.id;
      params['applyId'] = _applyInfo.id;
      if (_applyType == 0 && _applyInfo.shopApplyMember.id > 0) {
        params['id'] = _applyInfo.shopApplyMember.id;
      } else if (_applyType == 1 && _applyInfo.shopApplyCompany.id > 0) {
        params['id'] = _applyInfo.shopApplyCompany.id;
      }
    }
    // 外层参数
    body['applyType'] = _applyType;
    body['address'] = address;
    body['areaCode'] = _areaCode;
    body['cityCode'] = _cityCode;
    body['provinceCode'] = _provinceCode;
    body['shopDescription'] = description;
    body['shopLogo'] = _logoUrl;
    body['shopName'] = name;
    body['tagIds'] = _selectTagList.join(',');
    // 类型参数
    params['alipayAccount'] = aliPay;
    params['wechatAccount'] = weChat;
    if (_applyType == 1) {
      params['account'] = account;
      params['accountName'] = bank;
      params['address'] = address;
      params['areaCode'] = _areaCode;
      params['bankName'] = openBank;
      params['brandAuthImageUrl'] = _brandUrl;
      params['businessLicenseUrl'] = _businessUrl;
      params['cityCode'] = _cityCode;
      params['companyName'] = company;
      params['organizationName'] = name;
      params['phone'] = phone;
      params['practiceLicenceUrl'] = _organizationUrl;
      params['provinceCode'] = _provinceCode;
      params['servicePhone'] = telPhone;
      params['tradeMarkImageUrl'] = _tradeUrl;
      body['shopApplyCompany'] = params;
    } else {
      params['gender'] = _gender;
      params['hairdressingQualificationUrl'] = _diagnosisUrl;
      params['idCardBackImageUrl'] = _backUrl;
      params['idCardFrontImageUrl'] = _faceUrl;
      params['phone'] = phone;
      params['practiceUrl'] = _businessUrl;
      params['qualificationUrl'] = _quantificationUrl;
      params['realName'] = name;
      body['shopApplyMember'] = params;
    }
    // 请求接口提交
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.joinApply, body, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      // 申请成功
      Navigator.of(context).pushReplacement(
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
      appBar: CityWidgets.cityAppBar(
        context,
        '${_isGrounding ? '门店' : '商家'}入驻',
        () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 1),
            Offstage(
              offstage:
                  _applyInfo.auditStatus != 2 || _applyInfo.auditRemark.isEmpty,
              child: Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  '失败原因：${_applyInfo.auditRemark}',
                  style: TextStyle(color: XCColors.themeColor),
                ),
              ),
            ),
            SizedBox(height: 9),
            StoreWidgets.storeInfo(
              context,
              _applyType,
              _nameController,
              _describeController,
              _logoUrl,
              _isGrounding,
              () {
                _selectImage(0);
              },
              (type) {
                setState(
                  () {
                    _applyType = type;
                  },
                );
              },
            ),
            SizedBox(height: 10),
            Offstage(
              offstage: _applyType == 1,
              child: Container(
                padding: EdgeInsets.only(top: 10),
                width: double.infinity,
                color: Colors.white,
                child:
                    MultipleChoiceChipWidget(_tagList, _selectTagList, (list) {
                  setState(() {
                    this._selectTagList = list;
                  });
                }),
              ),
            ),
            Offstage(
              offstage: _applyType == 1,
              child: StoreWidgets.personInfo(
                context,
                _gender,
                _phoneController,
                _weChatController,
                _aliPayController,
                _faceUrl,
                _backUrl,
                _quantificationUrl,
                _businessUrl,
                _diagnosisUrl,
                _provinceName,
                _cityName,
                _areaName,
                _isGrounding,
                _selectArea,
                _selectImage,
                (type) {
                  setState(
                    () {
                      _gender = type;
                    },
                  );
                },
              ),
            ),
            Offstage(
              offstage: _applyType == 0,
              child: StoreWidgets.companyInfo(
                context,
                _companyController,
                _telPhoneController,
                _phoneController,
                _bankController,
                _openBankController,
                _accountController,
                _weChatController,
                _aliPayController,
                _addressController,
                _businessUrl,
                _organizationUrl,
                _brandUrl,
                _tradeUrl,
                _provinceName,
                _cityName,
                _areaName,
                _isGrounding,
                _selectArea,
                _selectImage,
              ),
            ),
            _applyInfo.auditStatus == 1 && _applyInfo.payStatus == 1
                ? SizedBox()
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        _isAgree = !_isAgree;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
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
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            child: RichText(
                              text: TextSpan(
                                text: '请仔细阅读并同意雀斑',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: XCColors.goodsGrayColor),
                                children: [
                                  TextSpan(
                                    text: '《入驻服务协议》',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: XCColors.bannerSelectedColor),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        NavigatorUtil.pushPage(
                                          context,
                                          ArticleScreen('h0jekec91'),
                                          needLogin: false,
                                        );
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
            _applyInfo.auditStatus == 1 && _applyInfo.payStatus == 1
                ? SizedBox()
                : GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _applySettle,
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: XCColors.themeColor,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Text(
                        '申请入驻',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
