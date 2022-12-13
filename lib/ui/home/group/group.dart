import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/group/category.dart';
import 'package:flutter_medical_beauty/ui/home/group/dialog.dart';

class GroupScreen extends StatefulWidget {
  final ScreeningParams homeParams;

  GroupScreen(this.homeParams);

  @override
  State<StatefulWidget> createState() => GroupScreenState();
}

class GroupScreenState extends State<GroupScreen>
    with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = ScrollController();
  List<TabEntity> _tabItems = <TabEntity>[];
  int _currentType = 0;
  ScreeningParams _screeningParams = ScreeningParams();

  List<HomeAddressEntity> _addressEntityList = <HomeAddressEntity>[];
  List<OrganizationEntity> _childrenList = <OrganizationEntity>[];

  List _distanceList = [
    {'city': '离我最近'},
    {'city': '0-5km'},
    {'city': '5-10km'},
    {'city': '10km以上'}
  ];
  List<HomeDistanceEntity> _distanceEntityList = <HomeDistanceEntity>[];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _screeningParams.latitude = widget.homeParams.latitude;
    _screeningParams.longitude = widget.homeParams.longitude;
    _screeningParams.cityCode = widget.homeParams.cityCode;
    _screeningParams.provinceCode = widget.homeParams.provinceCode;

    Future.delayed(Duration.zero, _init);
  }

  void _init() async {
    // 筛选初始化
    _distanceEntityList = _distanceList.map((value) {
      return HomeDistanceEntity.fromJson(value);
    }).toList();
    // _smartEntityList = _smartList.map((value) {
    //   return HomeSmartEntity.fromJson(value);
    // }).toList();
    // _welfareEntityList = _welfareList.map((value) {
    //   return HomeScreeningEntity.fromJson(value);
    // }).toList();
    // // 获取是否同意请求权限
    // bool isPrivacy = await Tool.isPrivacy();
    // if (isPrivacy) {
    //   // 定位
    //   _registerListener();
    // } else {
    //   setState(() {
    //     _locationTitle = '定位失败';
    //   });
    // }
    requestTabInfo();
  }

  void requestAreaInfo(int index) async {
    Map<String, String> params = Map();
    params['parentId'] = _screeningParams.cityCode;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.area, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
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

  void requestTabInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.tab, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
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

  /// 筛选取消事件
  void _screeningCancelAction() {
    setState(() {
      _currentType = 0;
    });
  }

  /// 筛选点击事件
  void _screeningAction(int type) {
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
        GroupDialog.showAddressList(
            context, _addressEntityList, _childrenList, _screeningParams, () {
          _screeningCancelAction();
        }, (result) {
          _screeningCancelAction();

          if (result.contains(',')) {
            requestOrgInfo(result);
          }
        });
      }
    }
    else if (type == 2) {
      /// 距离
      GroupDialog.showDistanceList(
          context, _distanceEntityList, _screeningParams, () {
        _screeningCancelAction();
      }, (result) {
        _screeningCancelAction();
      });
    }
    // else if (type == 3) {
    //   /// 智能排序
    //   HomeDialog.showSmartList(context, _smartEntityList, _screeningParams, () {
    //     _screeningCancelAction();
    //   }, (result) {
    //     _screeningCancelAction();
    //   });
    // } else if (type == 4) {
    //   /// 筛选
    //   HomeDialog.showScreeningList(
    //       context,
    //       _minTextEditingController,
    //       _maxTextEditingController,
    //       _organizationType,
    //       _welfareEntityList,
    //       _screeningParams, () {
    //     _screeningCancelAction();
    //   }, (result) {
    //     _screeningCancelAction();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _buildScreeningItem(int type, String title, VoidCallback onTap) {
      return Expanded(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(title,
                    style: TextStyle(
                        color: XCColors.tabNormalColor, fontSize: 14)),
                SizedBox(width: 10),
                Image.asset(
                    _currentType == type
                        ? "assets/images/home/home_arrow_up.png"
                        : "assets/images/home/home_arrow_down.png",
                    width: 10,
                    height: 5)
              ])));
    }

    Widget _buildTabController() {
      return DefaultTabController(
          length: _tabItems.length,
          child: Column(children: <Widget>[
            Container(
                height: 38,
                color: Colors.white,
                child: Row(children: [
                  _buildScreeningItem(1, '区域', () {
                    _screeningAction(1);
                  }),
                  _buildScreeningItem(2, '距离', () {
                    _screeningAction(2);
                  }),
                  _buildScreeningItem(3, '智能排序', () {
                    _screeningAction(3);
                  }),
                  _buildScreeningItem(4, '筛选', () {
                    _screeningAction(4);
                  })
                ])),
            Container(
                color: Colors.white,
                padding: EdgeInsets.only(top: 6, left: 7),
                height: 38,
                child: TabBar(
                    isScrollable: true,
                    labelColor: XCColors.bannerSelectedColor,
                    unselectedLabelColor: XCColors.mainTextColor,
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    unselectedLabelStyle: TextStyle(fontSize: 14),
                    indicatorColor: XCColors.bannerSelectedColor,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: List<Widget>.generate(_tabItems.length, (index) {
                      TabEntity entity = _tabItems[index];
                      return Tab(text: entity.name);
                    }))),
            SizedBox(height: 10),
            Expanded(
                child: TabBarView(
                    children: List<Widget>.generate(_tabItems.length, (index) {
              TabEntity entity = _tabItems[index];
              return GroupTabScreen(
                entity.id,
                _screeningParams,
              );
            })))
          ]));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '拼团专区', () {
          Navigator.pop(context);
        }),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            child: _tabItems.isEmpty ? Container() : _buildTabController()));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
