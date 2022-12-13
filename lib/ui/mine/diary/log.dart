import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class DiaryCreateLogScreen extends StatefulWidget {
  final int bookId;

  DiaryCreateLogScreen(this.bookId);

  @override
  State<StatefulWidget> createState() => DiaryCreateLogScreenState();
}

class DiaryCreateLogScreenState extends State<DiaryCreateLogScreen>
    with AutomaticKeepAliveClientMixin {
  List<Asset> _images = <Asset>[];
  TextEditingController _textEditingController = TextEditingController();
  String _count = '0/200';

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      setState(() {
        _count = '${_textEditingController.text.length}/200';
      });
    });
  }

  void _selectedImageAction() async {
    FocusScope.of(context).requestFocus(FocusNode());
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: _images,
        materialOptions: MaterialOptions(
          statusBarColor: "#92CFF3",
          actionBarColor: '#92CFF3',
          selectionLimitReachedText: '图片已达上限',
        ),
      );
    } on Exception catch (e) {
      //ToastHud.show(context, e.toString());
      return;
    }

    if (!mounted) return;

    setState(() {
      _images = resultList;
    });
  }

  void _saveAction() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_images.isEmpty) return ToastHud.show(context, '至少上传1张图片');
    if (_textEditingController.text.isEmpty)
      return ToastHud.show(context, '内容不能为空');

    List<String> results = <String>[];
    for (int i = 0; i < _images.length; i++) {
      Asset asset = _images[i];
      Map<String, String> param = Map<String, String>();
      param['key'] = asset.name!;
      ToastHud.loading(context);
      var http = await HttpManager.get(DsApi.ocsSign, context, params: param);
      if (http.code == 200) {
        COSSignEntity _cosSignEntity = COSSignEntity.fromJson(http.data);
        Map<String, String> headers = Map<String, String>();
        headers['Authorization'] = _cosSignEntity.sign;
        headers['x-cos-security-token'] = _cosSignEntity.sessionToken;
        ByteData byteData = await asset.getByteData();
        List<int> body = byteData.buffer.asUint8List();
        String url = _cosSignEntity.baseUrl + "/" + _cosSignEntity.key;
        HttpItem res = await HttpManager.uploadImage(url, headers, body);
        if (res.code == 200) {
          results.add(res.data);
          if (results.length == _images.length) {
            _uploadInfo(results);
          }
        } else {
          ToastHud.show(context, res.message!);
        }
      } else {
        ToastHud.show(context, http.message!);
      }
    }
  }

  void _uploadInfo(List<String> results) async {
    Map<String, String> params = Map();
    params['fileUrl'] = results.join(',');
    params['content'] = _textEditingController.text;
    params['fileType'] = '0';
    params['bookId'] = widget.bookId.toString();

    print('=====params==$params');
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.addOrUpdate, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '添加成功');
      Navigator.pop(context, '1');
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = (screenWidth - 76) / 3.0;
    int count = _images.length > 8 ? 9 : _images.length + 1;

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '新建日记', () {
        Navigator.pop(context);
      }),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 15, top: 10, right: 15, bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: XCColors.categoryGoodsShadowColor,
                            blurRadius: 6)
                      ]),
                  child: Text('上传图片',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: XCColors.mainTextColor))),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    boxShadow: [
                      BoxShadow(
                          color: XCColors.categoryGoodsShadowColor,
                          blurRadius: 6)
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Text('上传最新照片，最多9张',
                        style: TextStyle(
                            fontSize: 14, color: XCColors.mainTextColor)),
                    SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: count,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //横轴元素个数
                          crossAxisCount: 3,
                          //纵轴间距
                          mainAxisSpacing: 8,
                          //横轴间距
                          crossAxisSpacing: 8,
                          childAspectRatio: 1),
                      itemBuilder: (BuildContext context, int index) {
                        //Widget Function(BuildContext context, int index)
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => {
                            if (index > _images.length - 1)
                              {_selectedImageAction()}
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: imageWidth,
                                width: imageWidth,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                child: index > _images.length - 1
                                    ? Image.asset(
                                        'assets/images/mine/mine_diary_upload.png')
                                    : AssetThumb(
                                        asset: _images[index],
                                        width: int.parse(imageWidth
                                            .toString()
                                            .split('.')
                                            .first),
                                        height: int.parse(imageWidth
                                            .toString()
                                            .split('.')
                                            .first),
                                      ),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: Offstage(
                                  offstage: index > _images.length - 1,
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    onTap: () => {
                                      setState(() {
                                        _images.removeAt(index);
                                      })
                                    },
                                    child: Image.asset(
                                      'assets/images/home/home_detail_combo_close.png',
                                      color: Colors.red,
                                      width: 15,
                                      height: 15,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 15),
                    Container(height: 1, color: XCColors.homeDividerColor),
                    Container(
                      height: 224,
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: _textEditingController,
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.mainTextColor,
                        ),
                        maxLines: 50,
                        inputFormatters: <TextInputFormatter>[
                          LengthLimitingTextInputFormatter(200)
                        ],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '这一刻想说点什么呢？…',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: XCColors.tabNormalColor,
                          ),
                          hintMaxLines: 2,
                        ),
                      ),
                    ),
                    Container(height: 1, color: XCColors.homeDividerColor),
                    Container(
                      height: 37,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _count,
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.goodsGrayColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _saveAction,
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Text(
                    '保存',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
