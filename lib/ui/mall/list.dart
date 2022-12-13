import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mall/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MallTabBarView extends StatefulWidget {
  final int type;
  final ScreeningParams screeningParams;

  MallTabBarView(this.type, this.screeningParams);

  @override
  State<StatefulWidget> createState() => MallTabBarViewState();
}

class MallTabBarViewState extends State<MallTabBarView>
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
      _init();
    });

    Future.delayed(Duration.zero, _init);
  }

  void _init() {
    _currentPage = 1;
    requestInfo(0);
  }

  /// 请求
  void requestInfo(int type) async {
    Map<String, String> params = Map();

    params['pageNum'] = '$_currentPage';
    params['pageSize'] = '20';

    String provinceCode = widget.screeningParams.provinceCode;
    String cityCode = widget.screeningParams.cityCode;
    params['provinceCode'] = provinceCode;
    params['cityCode'] = cityCode;

    String latitude = widget.screeningParams.latitude;
    String longitude = widget.screeningParams.longitude;
    if (latitude.isNotEmpty) {
      params['latitude'] = latitude;
      params['longitude'] = longitude;
    }

    if (widget.type == 2) {
      params['groupFlag'] = "1";
    } else {
      params['productType'] = widget.type.toString();
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
      color: Colors.white,
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
              ),
      ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
