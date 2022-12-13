import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/case.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/doctor.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/goods.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/subscribe.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalScreen extends StatefulWidget {
  final int id;

  HospitalScreen(this.id);

  @override
  State<StatefulWidget> createState() => HospitalScreenState();
}

class HospitalScreenState extends State<HospitalScreen>
    with AutomaticKeepAliveClientMixin {
  OrgEntity _entity = OrgEntity();
  int _currentPage = 0;
  List<String> _pics = <String>[];
  PageController _pageController = PageController();
  bool _isGrounding = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestInfo();
  }

  void _requestInfo() async {
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.orgDetail + widget.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = OrgEntity.fromJson(http.data);
        if (_entity.pics.isNotEmpty) {
          _pics = _entity.pics.split(',');
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _changePage(int index) {
    setState(() {
      _currentPage = index + 1;
    });
  }

  void _pushAction(int type) {
    if (type == 1) {
      NavigatorUtil.pushPage(context, OrgSubscribeView(widget.id));
    } else if (type == 2) {
      NavigatorUtil.pushPage(context, OrgDoctorScreen(widget.id));
    } else if (type == 3) {
      NavigatorUtil.pushPage(context, OrgCaseView(widget.id));
    }
  }

  void _pushGoodsInfo() {
    NavigatorUtil.pushPage(context, OrgGoodsView(widget.id));
  }

  void _navigator() async {
    Map<String, dynamic> params = new Map();
    params['key'] = '00faaeb68a120f35e7ffa8dd88c81095';
    params['address'] = _entity.address;
    ToastHud.loading(context);
    Response response = await Dio().get(
      'https://restapi.amap.com/v3/geocode/geo',
      queryParameters: params,
    );
    ToastHud.dismiss();
    //成功获取数据
    if (response.statusCode == 200) {
      Map<String, dynamic> body = response.data;
      List geocodes = body['geocodes'];
      if (geocodes.isNotEmpty) {
        String location = geocodes[0]['location'];
        bool isAMap = await NavigatorUtil.gotoAMap(
            context, location.split(',')[0], location.split(',')[1]);
        if (!isAMap) {
          bool isTencentMap = await NavigatorUtil.gotoTencentMap(
              context, location.split(',')[0], location.split(',')[1]);
          if (!isTencentMap) {
            bool isBaiduMap = await NavigatorUtil.gotoBaiduMap(
                context, location.split(',')[0], location.split(',')[1]);
            if (!isBaiduMap) {
              ToastHud.show(context, '未安装任何地图软件，请先安装地图软件');
            }
          }
        }
      } else {
        ToastHud.show(context, '地图开启失败，请重试！');
      }
    } else {
      ToastHud.show(context, response.statusMessage ?? '地址转化失败，请重试！');
    }
  }

  void _bottomToolAction(int type) {
    if (type == 1) {
      if (_entity.telephone.isEmpty) {
        ToastHud.show(context, '当前${_isGrounding ? '门店' : '商家'}无联系号码，无法拨打电话！');
      } else {
        String phone = 'tel:${_entity.telephone}';
        launch(phone);
      }
    } else {
      ToastHud.show(context, '在线');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(
        context,
        _isGrounding ? '门店详情' : '商家详情',
        () {
          Navigator.pop(context);
        },
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HospitalWidgets.hospitalBanner(context, _pageController,
                      _pics, _currentPage, _changePage),
                  HospitalWidgets.hospitalInfo(
                    context,
                    _entity,
                    _isGrounding,
                    () {
                      _navigator();
                    },
                  ),
                  HospitalWidgets.hospitalNumber(
                    context,
                    _entity,
                    _isGrounding,
                    _pushAction,
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _pushGoodsInfo,
                      child: Container(
                          color: Colors.white,
                          margin: const EdgeInsets.only(top: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(children: [
                            Expanded(
                                child: Text('项目',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: XCColors.mainTextColor))),
                            Container(
                                height: 46,
                                child: Row(children: [
                                  Text('全部（${_entity.productList.total}）',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: XCColors.tabNormalColor)),
                                  SizedBox(width: 5),
                                  CommonWidgets.grayRightArrow()
                                ]))
                          ]))),
                  HospitalWidgets.hospitalGoods(context, _entity),
                  HospitalWidgets.hospitalDescribe(
                    context,
                    _entity,
                    _isGrounding,
                  ),
                  SizedBox(height: 80)
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child:
                HospitalWidgets.hospitalBottomBool(context, _bottomToolAction),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
