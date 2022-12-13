import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/info/dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FeedbackScreenState();
}

class FeedbackScreenState extends State<FeedbackScreen>
    with AutomaticKeepAliveClientMixin {
  var _selectedFile;
  TextEditingController _textEditingController = TextEditingController();
  String _count = '0/300';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textEditingController.addListener(() {
      setState(() {
        _count = '${_textEditingController.text.length}/300';
      });
    });

    super.initState();
  }

  void _selectPhoto(int type) async {
    FocusScope.of(context).requestFocus(FocusNode());
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

    setState(() {
      _selectedFile = file;
    });
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

  void _saveAction() {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_textEditingController.text.isEmpty)
      return ToastHud.show(context, '请输入反馈内容');

    if (_selectedFile == null) {
      _requestAction('');
    } else {
      uploadImage(_selectedFile);
    }
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
        _requestAction(res.data);
      } else {
        ToastHud.show(context, res.message!);
      }
    } else {
      ToastHud.show(context, http.message!);
    }
    ToastHud.dismiss();
  }

  void _requestAction(String image) async {
    Map<String, String> params = Map();
    params['opinionContent'] = _textEditingController.text;
    if (image.isNotEmpty) {
      params['opinionFile'] = image;
    }

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.opinion, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
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
      appBar: CityWidgets.cityAppBar(context, '意见反馈', () {
        Navigator.pop(context);
      }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 10,
                width: double.infinity,
                color: XCColors.homeDividerColor),
            Container(
              height: 264,
              color: Colors.white,
              padding: const EdgeInsets.all(15),
              child: TextField(
                controller: _textEditingController,
                style: TextStyle(fontSize: 14, color: XCColors.mainTextColor),
                maxLines: 50,
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(300)
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入您的意见或者建议（字数请控制在300字以内哦）',
                  hintStyle:
                      TextStyle(fontSize: 14, color: XCColors.tabNormalColor),
                  hintMaxLines: 2,
                ),
              ),
            ),
            Container(
                height: 1,
                width: double.infinity,
                color: XCColors.homeDividerColor),
            Container(
                alignment: Alignment.topLeft,
                height: 50,
                padding: const EdgeInsets.only(left: 15, top: 10),
                child: Text(_count,
                    style: TextStyle(
                        fontSize: 14, color: XCColors.tabNormalColor))),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                MineInfoDialog.showAvatarDialog(context, _selectPhoto);
              },
              child: Container(
                  height: 80,
                  width: 80,
                  margin: const EdgeInsets.only(left: 15),
                  padding: _selectedFile != null
                      ? EdgeInsets.symmetric(horizontal: 0)
                      : const EdgeInsets.symmetric(horizontal: 23),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: XCColors.storeCameraBgColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: _selectedFile != null
                      ? Image.file(File(_selectedFile.path), fit: BoxFit.cover)
                      : Image.asset(
                          "assets/images/mine/mine_store_upload.png")),
            ),
            SizedBox(height: 50),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _saveAction,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: XCColors.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Text(
                  '提交',
                  style: TextStyle(color: Colors.white, fontSize: 18),
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
