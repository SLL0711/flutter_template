import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/ui/consultation/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/goods.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/comment_list.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mall/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/video/pay.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../api.dart';
import '../../http.dart';
import '../../navigator.dart';
import '../../toast.dart';
import '../../tool.dart';
import '../../widgets.dart';

/// 咨询师详情
class ConsultantDetailScreen extends StatefulWidget {
  final int doctorId, productCategoryId;

  ConsultantDetailScreen(this.productCategoryId, this.doctorId);

  @override
  State<StatefulWidget> createState() => ConsultantDetailScreenState();
}

class ConsultantDetailScreenState extends State<ConsultantDetailScreen>
    with AutomaticKeepAliveClientMixin {
  MineEntity _userInfo = MineEntity();
  DoctorItemEntity _entity = DoctorItemEntity();
  double _price = 0;
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  List<CommentItemEntity> _commentList = <CommentItemEntity>[];
  int _totalGoods = 0, _totalComment = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() {
    _requestUserInfo();
    _requestConfigParamsInfo();
    _requestGoodsInfo();
    _requestCommentInfo();
  }

  /// 请求用户信息
  void _requestUserInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _userInfo = MineEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
    _requestInfo();
  }

  void _requestInfo() async {
    Map<String, dynamic> params = new Map();
    params['memberId'] = _userInfo.id;
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.doctorDetail + widget.doctorId.toString(),
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = DoctorItemEntity.fromJson(http.data);
        _entity.description =
            _entity.doctorProjectListVOS.map((e) => e.name).join('，');
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestGoodsInfo() async {
    Map<String, String> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '2';
    params['latitude'] = await Tool.getString('latitude');
    params['longitude'] = await Tool.getString('longitude');
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.doctorGoodsList + widget.doctorId.toString(),
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data);
      _totalGoods = entity.total;
      _itemEntityList = <ProductItemEntity>[];
      setState(() {
        _itemEntityList.addAll(entity.list);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestCommentInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '2';
    params['doctorId'] = widget.doctorId;

    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.doctorCommentList + widget.doctorId.toString(),
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      CommentEntity entity = CommentEntity.fromJson(http.data);
      setState(() {
        _commentList.addAll(entity.list);
        _totalComment = entity.total;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestConfigParamsInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.configParams, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _price = http.data['consultAmount'] ?? 0;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _attentionAction() async {
    Map<String, String> params = Map();
    params['doctorId'] = widget.doctorId.toString();

    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.focusDoctor,
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        if (_entity.isLike == 0) {
          _entity.isLike = 1;
          _entity.likeNumber++;
        } else {
          _entity.isLike = 0;
          _entity.likeNumber--;
        }
      });
      ToastHud.show(context, '关注成功');
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _videoAction() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPayScreen(
          widget.productCategoryId,
          _userInfo.id ?? 0,
          _entity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 375,
                      height: 375,
                      child: _entity.avatar.isEmpty
                          ? Image.asset('assets/images/mine/mine_avatar.png')
                          : CommonWidgets.networkImage(_entity.avatar),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 5,
                      left: 15,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => {Navigator.of(context).pop()},
                        child: Container(
                          width: 25,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: XCColors.mainTextColor),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset(
                            'assets/images/home/back.png',
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 5,
                      right: 15,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: _attentionAction,
                        child: Container(
                          width: 60,
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: XCColors.mainTextColor),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _entity.isLike == 1
                                  ? Container()
                                  : Image.asset(
                                      'assets/images/home/ic_focus.png',
                                      width: 15,
                                      height: 15,
                                    ),
                              Text(
                                _entity.isLike == 1 ? '已关注' : '关注',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: XCColors.mainTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.only(
                          left: 15,
                          top: 25,
                          right: 15,
                          bottom: 5,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _entity.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: XCColors.mainTextColor,
                                  ),
                                ),
                                SizedBox(width: 13),
                                Container(
                                  height: 14,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: XCColors.mainTextColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _entity.duties,
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ConsultationWidgets.scoreBigStar(
                                  context,
                                  _entity.score,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  _entity.score.toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.mainTextColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            Text(
                              '擅长：${_entity.description}',
                              style: TextStyle(
                                fontSize: 14,
                                color: XCColors.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 5,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                    color: XCColors.homeDividerColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _entity.organizationInfo.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: XCColors.mainTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              _entity.organizationInfo.address,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: XCColors.mainTextColor,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          String url =
                              '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=${_entity.organizationInfo.latitude}&lon=${_entity.organizationInfo.longitude}&dev=0&style=2&poiname=${_entity.organizationInfo.name}';
                          if (Platform.isIOS) {
                            url = Uri.encodeFull(url);
                          }
                          try {
                            await launch(url);
                          } on Exception catch (e) {
                            ToastHud.show(context, '无法调起高德地图');
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 45,
                          alignment: Alignment.center,
                          child: Image.asset(
                            'assets/images/home/home_address.png',
                            width: 16,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '服务项目',
                        style: TextStyle(
                          fontSize: 14,
                          color: XCColors.mainTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '全部($_totalGoods)',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabNormalColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => {
                          NavigatorUtil.pushPage(
                            context,
                            DoctorGoodsView(widget.doctorId),
                          )
                        },
                        child: Text(
                          '查看更多',
                          style: TextStyle(
                            fontSize: 12,
                            color: XCColors.tabNormalColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        'assets/images/home/ic_right.png',
                        width: 8,
                      ),
                    ],
                  ),
                ),
                StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                    left: 15,
                    top: 10,
                    right: 15,
                    bottom: 10,
                  ),
                  crossAxisCount: 4,
                  itemCount: _itemEntityList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(
                          context, DetailScreen(_itemEntityList[index].id),
                          needLogin: false);
                    },
                    child: MallWidgets.mallGoods(
                      context,
                      _itemEntityList[index],
                    ),
                  ),
                  staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  physics: NeverScrollableScrollPhysics(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '评价',
                        style: TextStyle(
                          fontSize: 14,
                          color: XCColors.mainTextColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '全部($_totalComment)',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabNormalColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Expanded(child: Container()),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => {
                          NavigatorUtil.pushPage(
                            context,
                            CommentListScreen(_entity.id, _entity.name),
                          )
                        },
                        child: Text(
                          '查看更多',
                          style: TextStyle(
                            fontSize: 12,
                            color: XCColors.tabNormalColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        'assets/images/home/ic_right.png',
                        width: 8,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: List.generate(
                    _commentList.length,
                    (index) {
                      CommentItemEntity itemEntity = _commentList[index];
                      return Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                        ),
                        padding: const EdgeInsets.all(10),
                        color: XCColors.homeDividerColor,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: CommonWidgets.networkImage(
                                itemEntity.memberIcon,
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        itemEntity.memberNickName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: XCColors.mainTextColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          itemEntity.createTime,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: XCColors.tabNormalColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    itemEntity.content,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: XCColors.mainTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 15),
              ],
            ),
          )),
          Container(
            margin: EdgeInsets.all(15),
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              color: XCColors.mainTextColor,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 15),
                Image.asset(
                  'assets/images/home/ic_white_video.png',
                  width: 24,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '专业咨询师1v1',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _videoAction,
                  child: Container(
                    width: 100,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      color: XCColors.themeColor,
                    ),
                    child: Text(
                      '¥$_price/去支付',
                      style: TextStyle(
                        fontSize: 14,
                        color: XCColors.mainTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
