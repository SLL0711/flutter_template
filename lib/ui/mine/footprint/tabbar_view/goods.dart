import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FootprintGoodsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FootprintGoodsScreenState();
}

class FootprintGoodsScreenState extends State<FootprintGoodsScreen>
    with AutomaticKeepAliveClientMixin {
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      init(0);
    });
  }

  void init(int type) async {
    Map<String, String> params = Map();
    params['pageNum'] = '$_currentPage';
    params['pageSize'] = '10';
    params['type'] = '0';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.footprintList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _itemEntityList.clear();
      }

      _currentPage++;
      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      setState(() {
        _itemEntityList.addAll(entity.list);
        if (type == 2) {
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
    init(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    init(1);
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
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          return HomeWidgets.homeRefresherFooter(context, mode);
        },
      ),
      child: _itemEntityList.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : ListView.builder(
              itemCount: _itemEntityList.length,
              itemBuilder: (context, index) {
                // if (index == 0 || index == 4) {
                //   return FootprintWidgets.listHeaderItem(context, index != 0);
                // }
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NavigatorUtil.pushPage(
                        context, DetailScreen(_itemEntityList[index].id),
                        needLogin: false);
                  },
                  child: FootprintWidgets.goodsItem(
                    context,
                    _itemEntityList[index],
                  ),
                );
              },
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
