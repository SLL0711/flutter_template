import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/city/citys.dart';
import 'package:flutter_medical_beauty/ui/mall/list.dart';
import 'package:flutter_medical_beauty/ui/mall/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../tool.dart';
import '../home/message/message.dart';

/// 商城首页
class MallScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MallScreenState();
}

class MallScreenState extends State<MallScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  ScrollController _scrollController = ScrollController();
  String _locationTitle = '定位中...';
  String _selectedTitle = '';
  var _addressEvent, _mineStateEvent;

  List<BannerEntity> _bannerInfo = <BannerEntity>[];
  ScreeningParams _screeningParams = ScreeningParams();
  ScreeningParams _locationParams = ScreeningParams();

  List<TabEntity> _tabItems = <TabEntity>[];

  /// 定位
  StreamSubscription<Map<String, Object>>? _locationListener;
  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  @override
  void dispose() {
    _scrollController.dispose();
    _addressEvent.cancel();
    _mineStateEvent.cancel();
    // 移除定位监听
    if (null != _locationListener) {
      _locationListener?.cancel();
    }
    // 销毁定位
    _locationPlugin.destroy();
    super.dispose();
  }

  @override
  void initState() {
    // 监听搜索地址的点击
    _addressEvent = EventCenter.defaultCenter().on<AddressEvent>().listen(
      (event) {
        if (event.result.isEmpty) return;
        setState(
          () {
            _selectedTitle = event.result;
          },
        );
      },
    );
    // 监听用户状态改变
    _mineStateEvent = EventCenter.defaultCenter().on<RefreshMineEvent>().listen(
      (event) {
        _init();
      },
    );
    // 初始化数据
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    // 获取是否同意请求权限
    bool isPrivacy = await Tool.isPrivacy();
    if (isPrivacy) {
      // 定位
      _registerListener();
    } else {
      setState(() {
        _locationTitle = '定位失败';
      });
    }
    requestBannerInfo();
    requestTabInfo();
  }

  /// 请求
  void requestBannerInfo() async {
    Map<String, String> params = Map();
    params['type'] = '2';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.banner, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          _bannerInfo.add(BannerEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void requestTabInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.tab, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _tabItems.clear();
        http.data.forEach((element) {
          _tabItems.add(TabEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  /// 定位
  void _registerListener() async {
    // 请求系统定位权限
    bool hasLocationPermission = await requestLocationPermission();
    if (hasLocationPermission) {
      /// 高德地图 定位功能
      AMapFlutterLocation.setApiKey("fe7c0b6b6073bd98cb0a7ca3edaa4335",
          "53c579d1a151911272adeef6028aaff2");

      if (Platform.isIOS) {
        requestAccuracyAuthorization();
      }

      // 获取定位结果的监听方法
      _locationListener = _locationPlugin
          .onLocationChanged()
          .listen((Map<String, Object> result) {
        print('====result===$result=');

        if (result['city'] == null) {
          setState(() {
            _locationTitle = '定位失败';
          });
        } else {
          _locationPlugin.stopLocation();
          _screeningParams.latitude = result['latitude'].toString();
          _screeningParams.longitude = result['longitude'].toString();
          _screeningParams.cityCode =
              result['adCode'].toString().substring(0, 4) + '00';
          _screeningParams.provinceCode =
              result['adCode'].toString().substring(0, 2) + '0000';
          _locationParams.latitude = result['latitude'].toString();
          _locationParams.longitude = result['longitude'].toString();
          _locationParams.cityCode =
              result['adCode'].toString().substring(0, 4) + '00';
          _locationParams.provinceCode =
              result['adCode'].toString().substring(0, 2) + '0000';
          //=========================定位地址缓存=================================
          Tool.saveString('province', result['province'].toString());
          Tool.saveString('city', result['city'].toString());
          Tool.saveString('district', result['district'].toString());
          Tool.saveString('provinceCode', _locationParams.provinceCode);
          Tool.saveString('cityCode', _locationParams.cityCode);
          Tool.saveString('districtCode', result['adCode'].toString());
          Tool.saveString('longitude', result['longitude'].toString());
          Tool.saveString('latitude', result['latitude'].toString());
          //====================================================================
          EventCenter.defaultCenter().fire(RefreshProductEvent(0));
          setState(() {
            _locationTitle = result['city'].toString();
          });
        }
      });

      // 配置定位的参数
      _setLocationOption();

      // 开始定位
      // 如果不需要在initState阶段调用定位则不需要这句
      _locationPlugin.startLocation();
    } else {
      setState(() {
        _locationTitle = '定位失败';
      });
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }

  void _setLocationOption() {
    AMapLocationOption locationOption = new AMapLocationOption();

    ///是否单次定位
    locationOption.onceLocation = true;

    ///是否需要返回逆地理信息
    locationOption.needAddress = true;

    ///逆地理信息的语言类型
    locationOption.geoLanguage = GeoLanguage.DEFAULT;

    locationOption.desiredLocationAccuracyAuthorizationMode =
        AMapLocationAccuracyAuthorizationMode.ReduceAccuracy;

    locationOption.fullAccuracyPurposeKey = "AMapLocationScene";

    ///设置Android端连续定位的定位间隔
    locationOption.locationInterval = 2000;

    ///设置Android端的定位模式<br>
    ///可选值：<br>
    ///<li>[AMapLocationMode.Battery_Saving]</li>
    ///<li>[AMapLocationMode.Device_Sensors]</li>
    ///<li>[AMapLocationMode.Hight_Accuracy]</li>
    locationOption.locationMode = AMapLocationMode.Hight_Accuracy;

    ///设置iOS端的定位最小更新距离<br>
    locationOption.distanceFilter = -1;

    ///设置iOS端期望的定位精度
    /// 可选值：<br>
    /// <li>[DesiredAccuracy.Best] 最高精度</li>
    /// <li>[DesiredAccuracy.BestForNavigation] 适用于导航场景的高精度 </li>
    /// <li>[DesiredAccuracy.NearestTenMeters] 10米 </li>
    /// <li>[DesiredAccuracy.Kilometer] 1000米</li>
    /// <li>[DesiredAccuracy.ThreeKilometers] 3000米</li>
    locationOption.desiredAccuracy = DesiredAccuracy.ThreeKilometers;

    ///设置iOS端是否允许系统暂停定位
    locationOption.pausesLocationUpdatesAutomatically = false;

    ///将定位参数设置给定位插件
    _locationPlugin.setLocationOption(locationOption);
  }

  ///获取iOS native的accuracyAuthorization类型
  void requestAccuracyAuthorization() async {
    AMapAccuracyAuthorization currentAccuracyAuthorization =
        await _locationPlugin.getSystemAccuracyAuthorization();
    if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationFullAccuracy) {
      print("精确定位类型");
    } else if (currentAccuracyAuthorization ==
        AMapAccuracyAuthorization.AMapAccuracyAuthorizationReducedAccuracy) {
      print("模糊定位类型");
    } else {
      print("未知定位类型");
    }
  }

  /// 地址和消息的点击事件
  void _titleViewAction(int type) {
    if (type == 1) {
      /// 跳转选择城市
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CityScreen(
            _locationTitle,
            _locationParams,
            _screeningParams,
          ),
        ),
      ).then((value) {
        if (value == null) return;
        // 切换地址 需要重新请求 区域接口
        setState(() {
          _selectedTitle = value;
        });
      });
    } else {
      /// 跳转消息
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MessageScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildTabController() {
      var menus = ["会员专区", "高级会员专区", "拼团专区"];
      return DefaultTabController(
        length: menus.length,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 4, left: 7),
              width: double.infinity,
              height: 40,
              child: menus.isEmpty
                  ? Container()
                  : TabBar(
                      isScrollable: true,
                      labelColor: XCColors.bannerSelectedColor,
                      unselectedLabelColor: XCColors.mainTextColor,
                      labelStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: TextStyle(fontSize: 14),
                      indicatorColor: Colors.white,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List<Widget>.generate(
                        menus.length,
                        (index) {
                          return Tab(text: menus[index]);
                        },
                      ),
                    ),
            ),
            Expanded(
              child: menus.isEmpty
                  ? Container()
                  : TabBarView(
                      children: List<Widget>.generate(
                        menus.length,
                        (index) {
                          return MallTabBarView(
                            index,
                            _screeningParams,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: MallWidgets.appBar(
        context,
        _selectedTitle.isEmpty ? _locationTitle : _selectedTitle,
        () => _titleViewAction(1),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        body: _buildTabController(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  MallWidgets.mallHeader(
                    context,
                    _tabItems,
                    _bannerInfo,
                    () {},
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
