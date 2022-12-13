import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/profit/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import '../../../api.dart';
import '../../../colors.dart';
import '../../../http.dart';
import '../../../toast.dart';

class InvitationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InvitationScreenState();
}

class InvitationScreenState extends State<InvitationScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  // 全局唯一键
  GlobalKey globalKey = GlobalKey();

  // 控制器
  late TabController _tabController = TabController(length: 1, vsync: this);
  PageController _pageController = PageController();
  int _currentIndex = 0;

  // 用户信息
  MineEntity _entity = MineEntity();

  // 海报图列表
  List<PosterEntity> _posterList = <PosterEntity>[];

  bool _isGrounding = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _requestData() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    Map<String, int> params = Map();
    params['pageNum'] = 1;
    params['pageSize'] = 20;
    var res = await HttpManager.get(DsApi.posterList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = MineEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
    // 海报列表
    if (res.code == 200) {
      setState(() {
        _posterList = PosterListEntity.fromJson(res.data).list;
        // 初始化控制器
        _tabController = TabController(length: _posterList.length, vsync: this);
        _pageController = PageController(initialPage: 0);
      });
    } else {
      ToastHud.show(context, res.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '海报', () {
        Navigator.pop(context);
      }),
      body: Column(children: [
        Container(
          width: double.infinity,
          height: 1,
          color: Colors.white10,
        ),
        Expanded(
          child: RepaintBoundary(
            key: globalKey,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        PageView.builder(
                          controller: _pageController,
                          itemCount: _posterList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 10, right: 10),
                              child: CommonWidgets.networkImage(
                                  _posterList[index].imageUrl),
                            );
                          },
                          onPageChanged: (index) {
                            _currentIndex = index;
                            // 要到新页面的时候 把新页面的index给我们
                            _tabController.animateTo(index);
                          },
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Container(
                              child: XCPageSelector(
                                controller: _tabController,
                                color: XCColors.bannerNormalColor,
                                selectedColor: XCColors.bannerSelectedColor,
                                indicatorSize: 4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        width: 60,
                        height: 60,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: _entity.icon == ''
                            ? Image.asset('assets/images/mine/mine_avatar.png')
                            : CommonWidgets.networkImage(_entity.icon ?? ''),
                      ),
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _entity.nickName ?? '雀斑',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            '长按右方二维码了解详情吧！',
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        margin: EdgeInsets.only(right: 8),
                        child: QrImage(
                          data: DsApi.share_url +
                              '?inviteCode=${_entity.inviteCode ?? ''}',
                          size: 60,
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                  Center(
                    child: Container(
                      width: 160,
                      height: 36,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '邀请码：',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            _entity.inviteCode ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 6),
                    child: Text(
                      _isGrounding ? '期待你加入雀斑' : '加入雀斑，我们一起变美一起赚钱！',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                ],
              ),
            ),
          ),
        ),
        _buildBottom(),
      ]),
    );
  }

  Widget _buildBottom() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      color: Colors.white10,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                ToastHud.show(context, '微信启动中，请稍后...');
                var model = fluwx.WeChatShareWebPageModel(
                    DsApi.share_url + '?inviteCode=${_entity.inviteCode ?? ''}',
                    title: '雀斑-${_entity.nickName}',
                    description:
                        _isGrounding ? '期待你加入雀斑' : '邀请你加入雀斑会员，带你一起变美一起赚钱！',
                    thumbnail: fluwx.WeChatImage.network(
                        _posterList[_currentIndex].imageUrl),
                    scene: fluwx.WeChatScene.SESSION);
                fluwx.shareToWeChat(model);
              },
              child: Container(
                padding: EdgeInsets.only(top: 20, bottom: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/home/home_detail_share_wechat.png',
                        width: 45,
                        height: 45,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        '微信好友',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                ToastHud.show(context, '微信启动中，请稍后...');
                var model = fluwx.WeChatShareWebPageModel(
                    DsApi.share_url + '?inviteCode=${_entity.inviteCode ?? ''}',
                    title: '雀斑-${_entity.nickName}',
                    description:
                        _isGrounding ? '期待你加入雀斑' : '邀请你加入雀斑会员，带你一起变美一起赚钱！',
                    thumbnail: fluwx.WeChatImage.network(
                        _posterList[_currentIndex].imageUrl),
                    scene: fluwx.WeChatScene.TIMELINE);
                fluwx.shareToWeChat(model);
              },
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/home/home_detail_share_friends.png',
                        width: 45,
                        height: 45,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        '朋友圈',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _saveImage(globalKey);
              },
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 20),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/home/home_detail_share_save.png',
                        width: 45,
                        height: 45,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Center(
                      child: Text(
                        '保存',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 保存图片
  void _saveImage(GlobalKey globalKey) async {
    try {
      ToastHud.loading(context);
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 6.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List picBytes = byteData!.buffer.asUint8List();

      bool isPermission = await _checkPermission();
      if (isPermission) {
        final result = await ImageGallerySaver.saveImage(picBytes,
            quality: 100, name: "share");
        ToastHud.dismiss();
        ToastHud.show(context,
            result['isSuccess'] ? '保存成功' : '保存失败，${result['errorMessage']}');
        debugPrint("save poster :" + result.toString());
      } else {
        ToastHud.dismiss();
        ToastHud.show(context, "保存失败，没有存储权限！");
        debugPrint('no permission');
      }
    } catch (e) {
      ToastHud.dismiss();
      ToastHud.show(context, "保存失败，请重试！");
      debugPrint(e.toString());
    }
  }

  /// 确认存储权限
  Future<bool> _checkPermission() async {
    if (Platform.isIOS) {
      var status = await Permission.photos.status;
      if (status.isGranted) {
        return true;
      } else {
        status = await Permission.photos.request();
        return status.isGranted;
      }
    } else if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      } else {
        status = await Permission.storage.request();
        return status.isGranted;
      }
    } else {
      return true;
    }
  }

  @override
  bool get wantKeepAlive => true;
}
