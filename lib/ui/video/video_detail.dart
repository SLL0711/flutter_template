import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/video/pay.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../api.dart';

class VideoDetailScreen extends StatefulWidget {
  final int doctorId, productCategoryId;

  VideoDetailScreen(this.productCategoryId, this.doctorId);

  @override
  State<StatefulWidget> createState() => VideoDetailScreenState();
}

class VideoDetailScreenState extends State<VideoDetailScreen>
    with AutomaticKeepAliveClientMixin {
  MineEntity _userInfo = MineEntity();
  DoctorItemEntity _entity = DoctorItemEntity();
  double _price = 0;

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() {
    _requestUserInfo();
    _requestConfigParamsInfo();
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

    Widget _buildImageItem(String title, String image) {
      return Container(
          child: Row(
        children: [
          Container(
            width: 14,
            height: 14,
            child: Image.asset(image, fit: BoxFit.fill),
          ),
          SizedBox(width: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF777777),
            ),
          ),
        ],
      ));
    }

    Widget _buildInfo() {
      return Container(
        padding: EdgeInsets.only(left: 35),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  _entity.name,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF020202),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  height: 12,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft, //右上
                      end: Alignment.centerRight, //左下
                      stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                      //渐变颜色[始点颜色, 结束颜色]
                      colors: [Color(0xFFF2A664), Color(0xFFFAD29D)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _entity.duties,
                    style: TextStyle(
                      fontSize: 7,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 15),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _attentionAction,
                  child: Image.asset(
                    _entity.isLike == 1
                        ? 'assets/images/video/video_is_like.png'
                        : 'assets/images/video/video_like.png',
                    width: 17,
                    height: 15,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/video/video_star.png',
                  width: 89,
                  height: 14,
                ),
                SizedBox(width: 10),
                Text(
                  '${_entity.commentNum}条评价',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: '咨询数：',
                    style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    children: [
                      TextSpan(
                        text: _entity.consultNum.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF599BA),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 25),
                RichText(
                  text: TextSpan(
                    text: '关注数：',
                    style: TextStyle(fontSize: 11, color: Color(0xFF666666)),
                    children: [
                      TextSpan(
                        text: _entity.likeNumber.toString(),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF599BA),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('咨询师标签：',
                    style: TextStyle(fontSize: 11, color: Color(0xFF666666))),
                SizedBox(width: 5),
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  alignment: WrapAlignment.start,
                  children: List.generate(
                    _entity.tagList.length,
                    (index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: XCColors.homeDividerColor),
                        child: Text(
                          _entity.tagList[index].tagName,
                          style:
                              TextStyle(fontSize: 10, color: Color(0xFF999999)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text(
              _entity.description,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                _buildImageItem(
                    '咨询师执业证', 'assets/images/video/video_license.png'),
                SizedBox(width: 10),
                _buildImageItem(
                    '咨询师资格证', 'assets/images/video/video_qualifications.png'),
                SizedBox(width: 10),
                _buildImageItem(
                    '主治咨询师资格证', 'assets/images/video/video_attending.png'),
                SizedBox(width: 10),
              ],
            ),
            SizedBox(height: 15),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              left: 0,
              child: Container(
                height: 136,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage('assets/images/video/video_detail_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
                top: MediaQuery.of(context).padding.top,
                right: 0,
                left: 0,
                child: Container(
                  height: 44,
                  child: Row(
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: kToolbarHeight,
                          width: kToolbarHeight,
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                            "assets/images/home/back.png",
                          ),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        '咨询',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.bold),
                      )),
                      Container(height: kToolbarHeight, width: kToolbarHeight)
                    ],
                  ),
                )),
            Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).padding.top + 44,
              child: Column(
                children: [
                  SizedBox(height: 26),
                  _buildInfo(),
                  SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.only(top: 35, bottom: 35),
                    color: Colors.white,
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          width: 200,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Color(0xFFB1E3FB)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Container(
                                width: 26,
                                height: 26,
                                child: Image.asset(
                                    'assets/images/video/video_logo.png'),
                              ),
                              SizedBox(height: 6),
                              Text(
                                '视频咨询',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF777777),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: 22,
                            padding: EdgeInsets.only(
                              left: 10,
                              top: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft, //右上
                                end: Alignment.centerRight, //左下
                                stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                                //渐变颜色[始点颜色, 结束颜色]
                                colors: [Color(0xFFF996B7), Color(0xFFB1E3FB)],
                              ),
                            ),
                            child: Text(
                              '只需要$_price元就能让专业咨询师1v1咨询哦',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -7,
                          right: -4,
                          child: Image.asset(
                            'assets/images/video/video_select.png',
                            width: 46,
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 44,
              right: 21,
              child: Container(
                width: 65,
                height: 65,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32.5),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 1.0,
                        offset: Offset(2, 2),
                        blurRadius: 10,
                        color: Colors.black12,
                      )
                    ]),
                child: _entity.avatar.isEmpty
                    ? Image.asset('assets/images/mine/mine_avatar.png')
                    : CommonWidgets.networkImage(_entity.avatar),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 44 + 55,
              right: 34,
              child: Container(
                height: 14,
                padding: EdgeInsets.symmetric(horizontal: 6),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  color: _entity.consultStatus > 0
                      ? Color(0xFFB2E6FA)
                      : Color(0xFFB8B8B8),
                ),
                child: Text(
                  _entity.consultStatus == 2
                      ? '咨询中'
                      : _entity.consultStatus == 1
                          ? ' 在线 '
                          : ' 离线 ',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 30,
              right: 13,
              left: 13,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _videoAction,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: XCColors.themeColor,
                  ),
                  child: Text(
                    '立即咨询',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
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
