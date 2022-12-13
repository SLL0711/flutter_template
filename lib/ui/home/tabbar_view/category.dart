import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets.dart';

class CategoryTabBarView extends StatefulWidget {
  final int type;
  final ScreeningParams screeningParams;

  CategoryTabBarView(this.type, this.screeningParams);

  @override
  State<StatefulWidget> createState() => CategoryTabBarViewState();
}

class CategoryTabBarViewState extends State<CategoryTabBarView>
    with AutomaticKeepAliveClientMixin {
  /// === 变量 ===
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  StreamSubscription? _subscription;
  int _currentPage = 1;

  @override
  void dispose() {
    _refreshController.dispose();
    _subscription!.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // 监听条件变化
    _subscription =
        EventCenter.defaultCenter().on<RefreshProductEvent>().listen((event) {
      _currentPage = 1;
      requestInfo(0);
    });

    Future.delayed(Duration.zero, () {
      _init();
    });
  }

  void _init() {
    requestInfo(0);
  }

  /// 请求
  void requestInfo(int type) async {
    Map<String, String> params = Map();
    if (widget.type == -1) {
      params['recommendFlag'] = '1';
    } else {
      params['categoryId'] = '${widget.type}';
    }
    params['pageNum'] = '$_currentPage';
    params['pageSize'] = '20';

    String cityCode = widget.screeningParams.cityCode;
    String latitude = widget.screeningParams.latitude;
    String longitude = widget.screeningParams.longitude;
    String provinceCode = widget.screeningParams.provinceCode;
    if (latitude.isNotEmpty) {
      params['cityCode'] = cityCode;
      params['latitude'] = latitude;
      params['longitude'] = longitude;
      params['provinceCode'] = provinceCode;
    }

    int distanceFilterType = widget.screeningParams.distanceFilterType;
    int minDistance = widget.screeningParams.minDistance;
    int maxDistance = widget.screeningParams.maxDistance;
    if (distanceFilterType != 0) {
      params['distanceFilterType'] = distanceFilterType.toString();
      if (distanceFilterType == 2) {
        params['minDistance'] = minDistance.toString();
        params['maxDistance'] = maxDistance.toString();
      }
    }

    int cleverSortType = widget.screeningParams.cleverSortType;
    if (cleverSortType != 0) {
      params['cleverSortType'] = cleverSortType.toString();
    }

    int orgId = widget.screeningParams.orgId;
    if (orgId != 0) {
      params['orgId'] = orgId.toString();
    }

    int orgTypeId = widget.screeningParams.orgTypeId;
    if (orgTypeId != 0) {
      params['orgTypeId'] = orgTypeId.toString();
    }

    int minPrice = widget.screeningParams.minPrice;
    if (minPrice != 0) {
      params['minPrice'] = minPrice.toString();
    }

    int maxPrice = widget.screeningParams.maxPrice;
    if (maxPrice != 0) {
      params['maxPrice'] = maxPrice.toString();
    }

    int groupFlag = widget.screeningParams.groupFlag;
    if (groupFlag != -1) {
      params['groupFlag'] = groupFlag.toString();
    }

    print('=====params==$params');
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.productList,
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data);
      if (_currentPage == 1) {
        _itemEntityList = <ProductItemEntity>[];
      }
      _currentPage++;
      setState(() {
        _itemEntityList.addAll(entity.list);
        if (type == 1) {
          if (entity.total == _itemEntityList.length) {
            _refreshController.loadNoData();
          } else {
            _refreshController.loadComplete();
          }
        }
      });
    } else {
      ToastHud.show(context, http.message!);
      if (type == 1) {
        _refreshController.loadFailed();
      }
    }
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    requestInfo(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: XCColors.homeDividerColor,
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _init,
        onLoading: _onLoading,
        header: MaterialClassicHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            return HomeWidgets.homeRefresherFooter(context, mode);
          },
        ),
        child: _itemEntityList.isEmpty
            ? Container(height: 350, child: EmptyWidgets.dataEmptyView(context))
            : StaggeredGridView.countBuilder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(
                    left: 15, top: 10, right: 15, bottom: 10),
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
                  child: HomeWidgets.homeGoodsTile(
                    context,
                    _itemEntityList[index],
                  ),
                ),
                staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
      ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
