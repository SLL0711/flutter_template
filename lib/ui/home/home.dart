import 'dart:async';
import 'dart:io';

import 'package:amap_flutter_location/amap_flutter_location.dart';
import 'package:amap_flutter_location/amap_location_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/city/citys.dart';
import 'package:flutter_medical_beauty/ui/home/dialog.dart';
import 'package:flutter_medical_beauty/ui/home/group/group.dart';
import 'package:flutter_medical_beauty/ui/home/tabbar_view/category.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../tool.dart';
import 'message/message.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  ScrollController _scrollController = ScrollController();
  String _locationTitle = '定位中...';
  String _selectedTitle = '';
  int _currentType = 0;
  int _groupFlag = 0;
  var _addressEvent, _mineStateEvent;
  TextEditingController _minTextEditingController = TextEditingController();
  TextEditingController _maxTextEditingController = TextEditingController();

  List<BannerEntity> _bannerInfos = <BannerEntity>[];
  BannerEntity _bannerEntity = BannerEntity();
  ScreeningParams _screeningParams = ScreeningParams();
  ScreeningParams _locationParams = ScreeningParams();

  List<TabEntity> _tabItems = <TabEntity>[];

  /// 定位
  StreamSubscription<Map<String, Object>>? _locationListener;
  AMapFlutterLocation _locationPlugin = new AMapFlutterLocation();

  List<HomeAddressEntity> _addressEntityList = <HomeAddressEntity>[];
  List<OrganizationEntity> _childrenList = <OrganizationEntity>[];

  List _distanceList = [
    {'city': '离我最近'},
    {'city': '0-5km'},
    {'city': '5-10km'},
    {'city': '10km以上'}
  ];
  List<HomeDistanceEntity> _distanceEntityList = <HomeDistanceEntity>[];

  List _smartList = [
    {'city': '智能排序'},
    {'city': '人气最高'},
    {'city': '综合评价'},
    {'city': '销量最多'},
    {'city': '最新上架'},
    {'city': '价格最高'},
    {'city': '价格最低'}
  ];
  List<HomeSmartEntity> _smartEntityList = <HomeSmartEntity>[];

  List<OrganizationTypeEntity> _organizationType = <OrganizationTypeEntity>[];

  List _welfareList = [
    {'city': '拼团'}
  ];
  List<HomeScreeningEntity> _welfareEntityList = <HomeScreeningEntity>[];

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
        requestAreaInfo(0);
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

    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    // 筛选初始化
    _distanceEntityList = _distanceList.map((value) {
      return HomeDistanceEntity.fromJson(value);
    }).toList();
    _smartEntityList = _smartList.map((value) {
      return HomeSmartEntity.fromJson(value);
    }).toList();
    _welfareEntityList = _welfareList.map((value) {
      return HomeScreeningEntity.fromJson(value);
    }).toList();
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
    requestAdInfo();
    requestTabInfo();
    requestTypeInfo();
  }

  /// 请求
  void requestBannerInfo() async {
    Map<String, String> params = Map();
    params['type'] = '1';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.banner, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          _bannerInfos.add(BannerEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void requestAdInfo() async {
    Map<String, String> params = Map();
    params['type'] = '2';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.banner, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      List<BannerEntity> _adInfos = <BannerEntity>[];
      http.data.forEach((element) {
        _adInfos.add(BannerEntity.fromJson(element));
      });
      if (_adInfos.isNotEmpty) {
        setState(() {
          _bannerEntity = _adInfos.first;
        });
      }
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
        TabEntity entity = TabEntity();
        entity.id = -1;
        entity.name = '推荐';
        _tabItems.add(entity);
        http.data.forEach((element) {
          _tabItems.add(TabEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void requestAreaInfo(int index) async {
    Map<String, String> params = Map();
    params['parentId'] = _screeningParams.cityCode;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.area, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _addressEntityList.clear();
        http.data.forEach((element) {
          _addressEntityList.add(HomeAddressEntity.fromJson(element));
        });
      });
      requestOrgInfo(
          '${_screeningParams.provinceCode},${_screeningParams.cityCode}');
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void requestOrgInfo(String value) async {
    List<String> values = value.split(',');

    Map<String, String> params = Map();
    params['provinceCode'] = values.first;
    params['cityCode'] = values.last;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.org, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      _childrenList.clear();
      setState(() {
        http.data.forEach((element) {
          _childrenList.add(OrganizationEntity.fromJson(element));
        });
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void requestTypeInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.orgType, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        http.data.forEach((element) {
          _organizationType.add(OrganizationTypeEntity.fromJson(element));
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
          requestAreaInfo(0);
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
        requestAreaInfo(0);
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

  /// 切换模块事件
  void _changeSectionAction(int flag) {
    setState(() {
      _groupFlag = flag;
    });
    _screeningParams.groupFlag = flag;
    EventCenter.defaultCenter().fire(RefreshProductEvent(1));
  }

  /// 筛选取消事件
  void _screeningCancelAction() {
    setState(() {
      _currentType = 0;
    });
  }

  /// 筛选点击事件
  void _screeningAction(int type) {
    // 滑动到指定位置
    double offsetY = 342;
    if (_scrollController.offset < offsetY) {
      _scrollController.animateTo(
        offsetY,
        duration: new Duration(milliseconds: 300), // 300ms
        curve: Curves.bounceIn,
      );
    }

    // 筛选箭头的变化
    setState(() {
      _currentType = type;
    });

    if (type == 1) {
      if (_addressEntityList.isEmpty) {
        _screeningCancelAction();
        if (_screeningParams.cityCode.isEmpty) {
          ToastHud.show(context, '定位失败');
        } else {
          requestAreaInfo(1);
        }
      } else {
        /// 区域
        HomeDialog.showAddressList(
            context, _addressEntityList, _childrenList, _screeningParams, () {
          _screeningCancelAction();
        }, (result) {
          _screeningCancelAction();

          if (result.contains(',')) {
            requestOrgInfo(result);
          }
        });
      }
    } else if (type == 2) {
      /// 距离
      HomeDialog.showDistanceList(
          context, _distanceEntityList, _screeningParams, () {
        _screeningCancelAction();
      }, (result) {
        _screeningCancelAction();
      });
    } else if (type == 3) {
      /// 智能排序
      HomeDialog.showSmartList(context, _smartEntityList, _screeningParams, () {
        _screeningCancelAction();
      }, (result) {
        _screeningCancelAction();
      });
    } else if (type == 4) {
      /// 筛选
      HomeDialog.showScreeningList(
          context,
          _minTextEditingController,
          _maxTextEditingController,
          _organizationType,
          _welfareEntityList,
          _screeningParams, () {
        _screeningCancelAction();
      }, (result) {
        _screeningCancelAction();
      });
    }
  }

  String _showDistance() {
    String distance = '距离';
    if (_screeningParams.distanceFilterType == 1) {
      distance = '离我最近';
    } else if (_screeningParams.distanceFilterType == 2) {
      switch (_screeningParams.minDistance) {
        case 0:
          distance = _distanceList[1]['city'];
          break;
        case 5:
          distance = _distanceList[2]['city'];
          break;
        case 10:
          distance = _distanceList[3]['city'];
          break;
      }
    }
    return distance;
  }

  String _showSort() {
    String sort = '智能排序';
    if (_screeningParams.cleverSortType > 0) {
      sort = _smartList[_screeningParams.cleverSortType - 1]['city'];
    }
    return sort;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildScreeningItem(int type, String title, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: XCColors.tabNormalColor,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 10),
              Image.asset(
                _currentType == type
                    ? "assets/images/home/home_arrow_up.png"
                    : "assets/images/home/home_arrow_down.png",
                width: 10,
                height: 5,
              )
            ],
          ),
        ),
      );
    }

    Widget _buildTabController() {
      return DefaultTabController(
        length: _tabItems.length,
        child: Column(
          children: <Widget>[
            Container(
              height: 40,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 30),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {_changeSectionAction(0)},
                      child: Text(
                        '会员专区',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: _groupFlag == 0
                              ? XCColors.detailSelectedColor
                              : XCColors.tabSelectedColor,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => {_changeSectionAction(1)},
                      child: Text(
                        '拼团专区',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: _groupFlag == 1
                              ? XCColors.detailSelectedColor
                              : XCColors.tabSelectedColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                ],
              ),
            ),
            Container(
                height: 38,
                color: Colors.white,
                child: Row(children: [
                  _buildScreeningItem(1, '区域', () {
                    _screeningAction(1);
                  }),
                  _buildScreeningItem(2, _showDistance(), () {
                    _screeningAction(2);
                  }),
                  _buildScreeningItem(3, _showSort(), () {
                    _screeningAction(3);
                  }),
                  _buildScreeningItem(4, '筛选', () {
                    _screeningAction(4);
                  })
                ])),
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(top: 6, left: 7),
              width: double.infinity,
              height: 38,
              child: _tabItems.isEmpty
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
                      indicatorColor: XCColors.detailSelectedColor,
                      indicatorWeight: 2,
                      indicatorSize: TabBarIndicatorSize.label,
                      tabs: List<Widget>.generate(
                        _tabItems.length,
                        (index) {
                          TabEntity entity = _tabItems[index];
                          return Tab(text: entity.name);
                        },
                      ),
                    ),
            ),
            Expanded(
              child: _tabItems.isEmpty
                  ? Container()
                  : TabBarView(
                      children: List<Widget>.generate(
                        _tabItems.length,
                        (index) {
                          TabEntity entity = _tabItems[index];
                          return CategoryTabBarView(
                            entity.id,
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
      appBar: HomeWidgets.homeAppBar(
        context,
        _selectedTitle.isEmpty ? _locationTitle : _selectedTitle,
        () => _titleViewAction(1),
        () => _titleViewAction(2),
      ),
      body: NestedScrollView(
        controller: _scrollController,
        body: _buildTabController(),
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  HomeWidgets.homeHeader(
                    context,
                    _bannerInfos,
                    _bannerEntity,
                    () {
                      NavigatorUtil.pushPage(
                          context, GroupScreen(_screeningParams),
                          needLogin: false);
                    },
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
