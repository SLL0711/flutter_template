import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/category.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

class OrderCommentScreen extends StatefulWidget {
  final MineOrderEntity order;

  OrderCommentScreen(this.order);

  @override
  State<StatefulWidget> createState() => OrderCommentScreenState();
}

class OrderCommentScreenState extends State<OrderCommentScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isGood = true;
  int _totalScore = 1;
  int _environmentScore = 1;
  int _professionalScore = 1;
  int _serviceScore = 1;
  int _effectScore = 1;
  int _doctorScore = 1;
  int _orgScore = 1;
  TextEditingController _contentTextEditingController = TextEditingController();
  TextEditingController _doctorTextEditingController = TextEditingController();
  TextEditingController _orgTextEditingController = TextEditingController();
  List<Asset> _contentImages = <Asset>[];
  List<Asset> _doctorImages = <Asset>[];
  List<Asset> _orgImages = <Asset>[];
  String _contentCount = '0/200';
  String _doctorCount = '0/200';
  String _orgCount = '0/200';
  bool _isGrounding = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
    _contentTextEditingController.addListener(() {
      setState(() {
        _contentCount = '${_contentTextEditingController.text.length}/200';
      });
    });

    _doctorTextEditingController.addListener(() {
      setState(() {
        _doctorCount = '${_doctorTextEditingController.text.length}/200';
      });
    });

    _orgTextEditingController.addListener(() {
      setState(() {
        _orgCount = '${_orgTextEditingController.text.length}/200';
      });
    });
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
  }

  @override
  void dispose() {
    _contentTextEditingController.dispose();
    _doctorTextEditingController.dispose();
    _orgTextEditingController.dispose();
    super.dispose();
  }

  void _selectedImageAction(int type) async {
    FocusScope.of(context).requestFocus(FocusNode());
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 9,
        enableCamera: true,
        selectedAssets: type == 1
            ? _contentImages
            : type == 2
                ? _doctorImages
                : _orgImages,
      );
    } on Exception catch (e) {
      ToastHud.show(context, e.toString());
    }

    if (!mounted) return;

    setState(() {
      if (type == 1) {
        _contentImages = resultList;
      } else if (type == 2) {
        _doctorImages = resultList;
      } else {
        _orgImages = resultList;
      }
    });
  }

  void _saveAction() async {
    FocusScope.of(context).requestFocus(FocusNode());

    if (_contentImages.isEmpty) return
      ToastHud.show(context, '至少上传1张评价图片');
    if (_doctorImages.isEmpty) return
      ToastHud.show(context, '至少上传1张咨询师图片');
    if (_orgImages.isEmpty) return
      ToastHud.show(context, '至少上传1张商家图片');

    if (_contentImages.isEmpty) {
      _uploadDoctorInfo('');
    } else {
      List<String> results = <String>[];
      for (int i = 0; i < _contentImages.length; i++) {
        Asset asset = _contentImages[i];
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
            if (results.length == _contentImages.length) {
              _uploadDoctorInfo(results.join(','));
            }
          } else {
            ToastHud.show(context, res.message!);
          }
        } else {
          ToastHud.show(context, http.message!);
        }
      }
    }
  }

  void _uploadDoctorInfo(String contentFiles) async {
    if (_doctorImages.isEmpty) {
      _uploadOrgInfo(contentFiles, '');
    } else {
      List<String> results = <String>[];
      for (int i = 0; i < _doctorImages.length; i++) {
        Asset asset = _doctorImages[i];
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
            if (results.length == _doctorImages.length) {
              _uploadOrgInfo(contentFiles, results.join(','));
            }
          } else {
            ToastHud.show(context, res.message!);
          }
        } else {
          ToastHud.show(context, http.message!);
        }
      }
    }
  }

  void _uploadOrgInfo(String contentFiles, String doctorFiles) async {
    if (_orgImages.isEmpty) {
      _uploadTotalInfo(contentFiles, doctorFiles, '');
    } else {
      List<String> results = <String>[];
      for (int i = 0; i < _orgImages.length; i++) {
        Asset asset = _orgImages[i];
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
            if (results.length == _orgImages.length) {
              _uploadTotalInfo(contentFiles, doctorFiles, results.join(','));
            }
          } else {
            ToastHud.show(context, res.message!);
          }
        } else {
          ToastHud.show(context, http.message!);
        }
      }
    }
  }

  void _uploadTotalInfo(
    String contentFiles,
    String doctorFiles,
    String orgFiles,
  ) async {
    Map<String, dynamic> params = Map();
    params['commentResultType'] = _isGood ? 0 : 1;
    params['envScore'] = _environmentScore;
    params['majorScore'] = _professionalScore;
    params['orderId'] = widget.order.id;
    params['productId'] = widget.order.productId;
    params['resultScore'] = _effectScore;
    params['serveScore'] = _serviceScore;
    params['totalScore'] = _totalScore;
    params['content'] = _contentTextEditingController.text;
    params['pics'] = contentFiles;
    Map<String, dynamic> doctorParams = Map();
    doctorParams['hasPic'] = doctorFiles.isEmpty ? 0 : 1;
    doctorParams['totalScore'] = _doctorScore;
    doctorParams['pics'] = doctorFiles;
    doctorParams['content'] = _doctorTextEditingController.text;
    Map<String, dynamic> orgParams = Map();
    orgParams['hasPic'] = orgFiles.isEmpty ? 0 : 1;
    orgParams['totalScore'] = _orgScore;
    orgParams['pics'] = orgFiles;
    orgParams['content'] = _orgTextEditingController.text;
    params['doctorCommentDTO'] = doctorParams;
    params['organizationCommentDTO'] = orgParams;
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.commentRelease, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '评价成功');
      Navigator.pop(context);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 商品item
    Widget _goodsInfo() {
      return Container(
          height: 100,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(children: [
            Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: CommonWidgets.networkImage(widget.order.productPic)),
            SizedBox(width: 10),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(widget.order.productName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14)),
                  Expanded(child: Container()),
                  Row(children: [
                    Text('待评价',
                        style: TextStyle(
                            color: XCColors.tabNormalColor, fontSize: 14)),
                    Expanded(
                        child: Text(
                            '¥${widget.order.isAllPay == 1 ? widget.order.allPayAmount : widget.order.totalAmount}',
                            style: TextStyle(
                                color: XCColors.themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,),),),
                    Text('x1',
                        style: TextStyle(
                            color: XCColors.goodsGrayColor, fontSize: 14))
                  ])
                ]))
          ]));
    }

    Widget _checkButton(String title, bool isSelected) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            setState(() {
              FocusScope.of(context).requestFocus(FocusNode());
              _isGood = !_isGood;
            });
          },
          child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Image.asset(
                    isSelected
                        ? 'assets/images/box/box_check_selected.png'
                        : 'assets/images/box/box_check_normal.png',
                    width: 16,
                    height: 16),
                SizedBox(width: 5),
                Text(title,
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 14))
              ])));
    }

    Widget _checkOtherButton(String title, int score, int type) {
      return Container(
          height: 35,
          child: Row(children: [
            Container(
                width: 75,
                child: Text(title,
                    style: TextStyle(
                        color: XCColors.tabNormalColor, fontSize: 14))),
            SizedBox(width: 5),
            Row(
                children: List.generate(
                    5,
                    (index) => GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          setState(() {
                            if (type == 1) {
                              _environmentScore = index + 1;
                            } else if (type == 2) {
                              _professionalScore = index + 1;
                            } else if (type == 3) {
                              _serviceScore = index + 1;
                            } else if (type == 4) {
                              _effectScore = index + 1;
                            } else if (type == 5) {
                              _doctorScore = index + 1;
                            } else if (type == 6) {
                              _orgScore = index + 1;
                            } else if (type == 7) {
                              _totalScore = index + 1;
                            }
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.only(right: 5),
                            child: Image.asset(
                                index < score
                                    ? 'assets/images/home/home_detail_score.png'
                                    : 'assets/images/home/home_detail_no_score.png',
                                width: 16,
                                height: 16)))))
          ]));
    }

    Widget _content(String hint, TextEditingController textEditingController) {
      return Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1, color: XCColors.homeDividerColor),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: TextField(
              controller: textEditingController,
              style: TextStyle(fontSize: 12, color: XCColors.mainTextColor),
              maxLines: 50,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(200)
              ],
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle:
                      TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                  hintMaxLines: 2)));
    }

    Widget _photo(List<Asset> images, int type) {
      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      double imageWidth = (screenWidth - 76) / 3.0;
      int count = images.length > 8 ? 9 : images.length + 1;

      return Container(
          child: GridView.builder(
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
                return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      _selectedImageAction(type);
                    },
                    child: Container(
                        height: imageWidth,
                        width: imageWidth,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(6))),
                        child: index > images.length - 1
                            ? Image.asset(
                                'assets/images/mine/mine_diary_upload.png')
                            : AssetThumb(
                                asset: images[index],
                                width: int.parse(
                                    imageWidth.toString().split('.').first),
                                height: int.parse(
                                    imageWidth.toString().split('.').first),
                              )));
              }));
    }

    Widget _goodsComment() {
      return Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                height: 30,
                child: Row(children: [
                  Text('整体评价：',
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 14)),
                  SizedBox(width: 10),
                  _checkButton('好评', _isGood),
                  SizedBox(width: 10),
                  _checkButton('差评', !_isGood)
                ])),
            _checkOtherButton('综合评价：', _totalScore, 7),
            _checkOtherButton('环境：', _environmentScore, 1),
            _checkOtherButton('专业度：', _professionalScore, 2),
            _checkOtherButton('服务：', _serviceScore, 3),
            _checkOtherButton('效果：', _effectScore, 4),
            SizedBox(height: 10),
            _content('请输入您对商品的评价，使用效果等...', _contentTextEditingController),
            Container(
                height: 37,
                alignment: Alignment.centerRight,
                child: Text(_contentCount,
                    style: TextStyle(
                        fontSize: 12, color: XCColors.goodsGrayColor))),
            SizedBox(height: 5),
            _photo(_contentImages, 1)
          ]));
    }

    Widget _doctorComment() {
      return Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _checkOtherButton(
              _isGrounding ? '技师评价' : '咨询师评价：',
              _doctorScore,
              5,
            ),
            SizedBox(height: 10),
            _content('请输入您对${_isGrounding ? '技师' : '咨询师'}的评价',
                _doctorTextEditingController),
            Container(
                height: 37,
                alignment: Alignment.centerRight,
                child: Text(_doctorCount,
                    style: TextStyle(
                        fontSize: 12, color: XCColors.goodsGrayColor))),
            SizedBox(height: 5),
            _photo(_doctorImages, 2)
          ]));
    }

    Widget _orgComment() {
      return Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _checkOtherButton('${_isGrounding ? '门店' : '商家'}评价：', _orgScore, 6),
            SizedBox(height: 10),
            _content('请输入您对${_isGrounding ? '门店' : '商家'}的评价',
                _orgTextEditingController),
            Container(
                height: 37,
                alignment: Alignment.centerRight,
                child: Text(_orgCount,
                    style: TextStyle(
                        fontSize: 12, color: XCColors.goodsGrayColor))),
            SizedBox(height: 5),
            _photo(_orgImages, 3)
          ]));
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CityWidgets.cityAppBar(context, '评价', () {
          Navigator.pop(context);
        }),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(height: 10, color: XCColors.homeDividerColor),
          _goodsInfo(),
          Container(height: 10, color: XCColors.homeDividerColor),
          _goodsComment(),
          Container(height: 10, color: XCColors.homeDividerColor),
          _doctorComment(),
          Container(height: 10, color: XCColors.homeDividerColor),
          _orgComment(),
          SizedBox(height: 30),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _saveAction,
              child: Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: XCColors.bannerSelectedColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Text('发布',
                      style: TextStyle(fontSize: 18, color: Colors.white)))),
          SizedBox(height: 40),
        ])));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
