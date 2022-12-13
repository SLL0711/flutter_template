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
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../colors.dart';

class CollectionGoodsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionGoodsScreenState();
}

class CollectionGoodsScreenState extends State<CollectionGoodsScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _refreshEvent;
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  int _currentPage = 1;

  @override
  void dispose() {
    _refreshController.dispose();
    _refreshEvent.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _refreshEvent = EventCenter.defaultCenter()
        .on<RefreshCollectionEvent>()
        .listen((event) {
      _currentPage = 1;
      _requestInfo(0);
    });
    Future.delayed(Duration.zero, () {
      _requestInfo(0);
    });
    super.initState();
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = 20;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.collectList + '0', context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data['products']);
      if (_currentPage == 1) {
        _itemEntityList.clear();
      }
      _currentPage++;
      setState(() {
        _itemEntityList.addAll(entity.list);
        if (type == 1) {
          _refreshController.refreshCompleted();
        } else if (type == 2) {
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
        _refreshController.refreshFailed();
      } else if (type == 2) {
        _refreshController.loadFailed();
      }
    }
  }

  void _onLoading() {
    _requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestInfo(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onLoading: _onLoading,
        onRefresh: _onRefresh,
        header: MaterialClassicHeader(),
        footer: CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
          return HomeWidgets.homeRefresherFooter(context, mode);
        }),
        child: _itemEntityList.isEmpty
            ? EmptyWidgets.dataEmptyView(context)
            : Container(
                color: XCColors.homeDividerColor,
                child: StaggeredGridView.countBuilder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(
                        left: 15, top: 10, right: 15, bottom: 10),
                    crossAxisCount: 4,
                    itemCount: _itemEntityList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              NavigatorUtil.pushPage(context,
                                  DetailScreen(_itemEntityList[index].id),
                                  needLogin: false);
                            },
                            child: HomeWidgets.homeGoodsTile(
                                context, _itemEntityList[index])),
                    staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0)));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
