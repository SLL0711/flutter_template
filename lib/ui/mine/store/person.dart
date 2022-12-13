/*
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/info/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/store/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/store/review.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../colors.dart';
import '../../../api.dart';
import '../../../http.dart';
import '../../../toast.dart';
import '../entity.dart';
import 'widgets.dart';

class StorePersonScreen extends StatefulWidget {
  final Map<String, dynamic> baseData;
  final ApplyInfoEntity applyInfo;

  StorePersonScreen(this.baseData, this.applyInfo);

  @override
  State<StatefulWidget> createState() => StorePersonScreenState();
}

class StorePersonScreenState extends State<StorePersonScreen>
    with AutomaticKeepAliveClientMixin {
  // 身份证照片
  String _idCardFrontImageUrl = '',
      _idCardBackImageUrl = '',
      _idCardAndMemberUrl = '';

  // 选择照片位置
  int _imagePosition = 0;

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

  // 是否同意
  bool _isAgree = false;

  @override
  void initState() {
    if (widget.applyInfo.id != 0) {
      _initApplyInfo();
    }
    super.initState();
  }

  void _initApplyInfo() {
    ApplyPersonEntity entity = widget.applyInfo.shopApplyMember;
    _idCardFrontImageUrl = entity.idCardFrontImageUrl;
    _idCardBackImageUrl = entity.idCardBackImageUrl;
    _idCardAndMemberUrl = entity.idCardAndMemberUrl;
    _realNameController.text = entity.bankRealName;
    _identifyController.text = entity.bankIdCardNumber;
    _bankCardController.text = entity.bankCardNumber;
    _phoneController.text = entity.bankPhone;
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
          if (_imagePosition == 2) {
            _idCardAndMemberUrl = res.data;
          } else if (_imagePosition == 1) {
            _idCardBackImageUrl = res.data;
          } else {
            _idCardFrontImageUrl = res.data;
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

  /// 申请入驻
  void _applySettle() async {
    if (!_isAgree) {
      ToastHud.show(context, "请仔细阅读并同意协议");
      return;
    }
    String realName = _realNameController.text;
    String identity = _identifyController.text;
    String bankCard = _bankCardController.text;
    String phone = _phoneController.text;
    String weChat = _weChatController.text;
    String aliPay = _aliPayController.text;
    // 数据校验
    Map<String, dynamic> params = Map();
    if (widget.applyInfo.id > 0 && widget.applyInfo.shopApplyMember.id > 0) {
      params['applyId'] = widget.applyInfo.id;
      params['id'] = widget.applyInfo.shopApplyMember.id;
    }
    params['alipayAccount'] = aliPay;
    params['bankCardNumber'] = bankCard;
    params['bankIdCardNumber'] = identity;
    params['bankPhone'] = phone;
    params['bankRealName'] = realName;
    params['wechatAccount'] = weChat;
    params['idCardAndMemberUrl'] = _idCardAndMemberUrl;
    params['idCardBackImageUrl'] = _idCardBackImageUrl;
    params['idCardFrontImageUrl'] = _idCardFrontImageUrl;
    // 上一页参数
    params['email'] = widget.baseData['email'];
    params['idCardNumber'] = widget.baseData['idCardNumber'];
    params['phone'] = widget.baseData['phone'];
    params['realName'] = widget.baseData['realName'];
    // 请求的body
    Map<String, dynamic> body = widget.baseData;
    body['shopApplyMember'] = params;
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

            /// 个人
            StoreWidgets.storePersonHeaderView(
              context,
              _idCardFrontImageUrl,
              _idCardBackImageUrl,
              _idCardAndMemberUrl,
              (position) {
                _imagePosition = position;
                MineInfoDialog.showAvatarDialog(context, _selectImage);
              },
            ),
            SizedBox(height: 10),

            /// 个人的绑定提款，微信或支付宝
            StoreWidgets.storePersonBankView(
                context,
                _realNameController,
                _identifyController,
                _bankCardController,
                _phoneController,
                _weChatController,
                _aliPayController),
            SizedBox(height: 10),

            /// 入驻认证费用
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
