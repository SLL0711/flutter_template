import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/project.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

import 'entity.dart';

class DiaryEditScreen extends StatefulWidget {
  final int bookId;

  DiaryEditScreen(this.bookId);

  @override
  State<StatefulWidget> createState() => DiaryEditScreenState();
}

class DiaryEditScreenState extends State<DiaryEditScreen>
    with AutomaticKeepAliveClientMixin {
  String _selectedDateText = '';
  String _selectedProjectText = '';
  int _selectedProjectId = 0;
  int _selectedProductId = 0;
  DiaryBooksEntity _entity = new DiaryBooksEntity();
  List<Asset> _images = <Asset>[];
  List<String> _imageUrls = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    Map<String, dynamic> params = Map();
    params['diaryBookId'] = widget.bookId;
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.diaryBookDetail,
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = DiaryBooksEntity.fromJson(http.data);
        _selectedDateText = _entity.operationTime;
        _selectedProjectText = _entity.name;
        _selectedProductId = _entity.productId;
        _selectedProjectId = _entity.orderId;
        _imageUrls = _entity.beforeImages.split(',');
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _selectedProjectAction() {
    Navigator.push(
        context,
        CupertinoPageRoute<MineOrderEntity>(
            builder: (ctx) => DiaryProjectScreen())).then((value) {
      if (value == null) return;
      setState(() {
        _selectedProjectText = value.productName;
        _selectedProjectId = value.id;
        _selectedProductId = value.productId;
      });
    });
  }

  void _selectedDateAction() {
    DatePicker.showDatePicker(context,
        theme: DatePickerTheme(
          cancelStyle: TextStyle(fontSize: 16, color: XCColors.tabNormalColor),
          doneStyle: TextStyle(
            fontSize: 16,
            color: XCColors.mainTextColor,
          ),
        ),
        showTitleActions: true, onConfirm: (date) {
      setState(() {
        List<String> dates = date.toString().split(' ');
        _selectedDateText = dates.first;
      });
    }, locale: LocaleType.zh);
  }

  void _selectedImageAction() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9 - _imageUrls.length,
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
    if (_imageUrls.isEmpty && _images.isEmpty)
      return ToastHud.show(context, '至少上传1张图片');
    if (_selectedProjectText.isEmpty) return ToastHud.show(context, '请选择项目');
    if (_selectedDateText.isEmpty) return ToastHud.show(context, '请选择手术时间');

    List<String> results = <String>[];
    results.addAll(_imageUrls);
    if (_images.isEmpty) {
      _uploadInfo(results);
      return;
    }
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
          if (results.length == _imageUrls.length + _images.length) {
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
    params['beforeImages'] = results.join(',');
    params['operationTime'] = _selectedDateText;
    params['projectName'] = _selectedProjectText;
    params['orderId'] = _selectedProjectId.toString();
    params['productId'] = _selectedProductId.toString();
    params['id'] = widget.bookId.toString();
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.createOrUpdate, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '修改成功');
      Navigator.pop(context, '1');
      EventCenter.defaultCenter().fire(RefreshDiaryEvent(0));
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
    int count = _imageUrls.length + _images.length > 8
        ? 9
        : _imageUrls.length + _images.length + 1;

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '修改日记本', () {
        Navigator.pop(context);
      }),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 10),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    '上传术前照片，最多9张',
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                    ),
                  ),
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
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      //Widget Function(BuildContext context, int index)
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => {
                          if (index > _imageUrls.length + _images.length - 1)
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
                              child: index > _imageUrls.length - 1
                                  ? (index >
                                          _imageUrls.length + _images.length - 1
                                      ? Image.asset(
                                          'assets/images/mine/mine_diary_upload.png')
                                      : AssetThumb(
                                          asset: _images[
                                              index - _imageUrls.length],
                                          width: int.parse(imageWidth
                                              .toString()
                                              .split('.')
                                              .first),
                                          height: int.parse(imageWidth
                                              .toString()
                                              .split('.')
                                              .first),
                                        ))
                                  : CommonWidgets.networkImage(
                                      _imageUrls[index]),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: Offstage(
                                offstage: index >
                                    _imageUrls.length + _images.length - 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => {
                                    setState(() {
                                      if (index > _imageUrls.length - 1) {
                                        _images.removeAt(
                                            index - _imageUrls.length);
                                      } else {
                                        _imageUrls.removeAt(index);
                                      }
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _selectedProjectAction,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 1,
                            color: XCColors.homeDividerColor,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedProjectText.isEmpty
                                  ? '请选择项目'
                                  : _selectedProjectText,
                              style: TextStyle(
                                fontSize: 14,
                                color: XCColors.mainTextColor,
                              ),
                            ),
                          ),
                          CommonWidgets.grayRightArrow()
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _selectedDateAction,
                    child: Container(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDateText.isEmpty
                                  ? '提选择手术时间'
                                  : _selectedDateText,
                              style: TextStyle(
                                fontSize: 14,
                                color: XCColors.mainTextColor,
                              ),
                            ),
                          ),
                          CommonWidgets.grayRightArrow()
                        ],
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
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
                  ),
                ),
                child: Text(
                  '保存',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
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
