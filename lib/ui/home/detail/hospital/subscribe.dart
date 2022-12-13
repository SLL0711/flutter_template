import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../colors.dart';
import '../../widgets.dart';

class OrgSubscribeView extends StatefulWidget {
  final int id;

  OrgSubscribeView(this.id);

  @override
  State<StatefulWidget> createState() => OrgSubscribeViewState();
}

class OrgSubscribeViewState extends State<OrgSubscribeView>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _total = 0;
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  int _currentPage = 1;
  bool _isGrounding = false;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestInfo(0);
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['orgId'] = widget.id;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.doctorReserve, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ProductEntity entity = ProductEntity.fromJson(http.data);
      if (_currentPage == 1) {
        _itemEntityList = <ProductItemEntity>[];
      }
      _currentPage++;

      setState(() {
        _itemEntityList.addAll(entity.list);
        _total = entity.total;

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

    /// 商品item
    Widget _goodsItem(int index) {
      ProductItemEntity itemEntity = _itemEntityList[index];
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            NavigatorUtil.pushPage(
                context, DetailScreen(_itemEntityList[index].id),
                needLogin: false);
          },
          child: Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: XCColors.categoryGoodsShadowColor, blurRadius: 10)
              ], color: Colors.white),
              child: Row(children: [
                Container(
                    width: 80,
                    height: 80,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: CommonWidgets.networkImage(itemEntity.pic)),
                SizedBox(width: 15),
                Expanded(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(itemEntity.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: XCColors.mainTextColor, fontSize: 14)),
                      SizedBox(height: 15),
                      Row(children: [
                        Text('¥${itemEntity.minPrice}',
                            style: TextStyle(
                                color: XCColors.themeColor,
                                fontSize: 18,),),
                        SizedBox(width: 3),
                        Text('￥${itemEntity.price}',
                            style: TextStyle(
                                color: XCColors.goodsOtherGrayColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: XCColors.goodsOtherGrayColor,
                                fontSize: 12)),
                        Expanded(
                            child: Text('已预约 ${itemEntity.reserveNum}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: XCColors.goodsOtherGrayColor,
                                    fontSize: 11)))
                      ]),
                      SizedBox(height: 11)
                    ]))
              ])));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: AppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            centerTitle: true,
            elevation: 0,
            leading: Builder(builder: (BuildContext context) {
              return IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Image.asset("assets/images/home/back.png",
                      width: 28, height: 28),
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip);
            }),
            title: Text(_isGrounding ? '技师的预约' : '咨询师的预约',
                style: TextStyle(
                    fontSize: 18,
                    color: XCColors.mainTextColor,
                    fontWeight: FontWeight.bold)),
            actions: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text('全部（$_total）',
                          style: TextStyle(
                              fontSize: 12, color: XCColors.tabNormalColor))))
            ]),
        body: Column(children: [
          SizedBox(height: 10),
          Expanded(
              child: SmartRefresher(
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
                            return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  NavigatorUtil.pushPage(context,
                                      DetailScreen(_itemEntityList[index].id),
                                      needLogin: false);
                                },
                                child: Column(children: [
                                  _goodsItem(index),
                                  SizedBox(height: 10)
                                ]));
                          })))
        ]));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
