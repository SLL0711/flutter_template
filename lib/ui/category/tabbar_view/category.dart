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
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/category/dialog.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CategoryTabBarView extends StatefulWidget {
  final List<TabEntity> children;
  final int type;

  CategoryTabBarView(this.children, this.type);

  @override
  State<StatefulWidget> createState() => CategoryTabBarViewState();
}

class CategoryTabBarViewState extends State<CategoryTabBarView>
    with AutomaticKeepAliveClientMixin {
  BannerEntity _bannerEntity = BannerEntity();
  int _selectedId = 0;
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  StreamSubscription? _subscription;

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
        EventCenter.defaultCenter().on<RefreshCategoryEvent>().listen((event) {
      _selectedId = event.result;

      _currentPage = 1;
      requestInfo(0);
    });

    if (widget.children.isEmpty) {
      _selectedId = widget.type;
    } else {
      TabEntity entity = widget.children.first;
      entity.isSelected = true;
      _selectedId = entity.id;
    }

    Future.delayed(Duration.zero, () {
      init();
    });
  }

  void init() {
    requestAdInfo();
    requestInfo(0);
  }

  void requestAdInfo() async {
    Map<String, String> params = Map();
    params['type'] = '3';

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

  /// 请求
  void requestInfo(int type) async {
    Map<String, String> params = Map();
    params['categoryIId'] = '$_selectedId';
    params['pageNum'] = '$_currentPage';
    params['pageSize'] = '10';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.productList, context, params: params);
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
    requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    requestInfo(1);
  }

  void _tapTabItem(TabEntity entity) {
    setState(() {
      widget.children.forEach((element) {
        element.isSelected = false;
      });
      entity.isSelected = true;
    });

    _selectedId = entity.id;
    _currentPage = 1;
    requestInfo(0);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// 商品item
    Widget _goodsItem(int index) {
      ProductItemEntity itemEntity = _itemEntityList[index];
      if (itemEntity.minPrice == 0) {
        itemEntity.minPrice = itemEntity.price;
      }
      return Container(
        height: 110,
        margin: const EdgeInsets.only(left: 10, right: 15, bottom: 10),
        padding: const EdgeInsets.only(left: 10, right: 8),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 10)
        ], color: Colors.white),
        child: Row(
          children: [
            Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: CommonWidgets.networkImage(itemEntity.pic)),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 9),
                  Text(
                    itemEntity.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        itemEntity.isEnableFee == 1
                            ? '免费体验'
                            : '¥${itemEntity.minPrice}',
                        style: TextStyle(
                          color: XCColors.themeColor,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          '￥${itemEntity.price}',
                          style: TextStyle(
                            color: XCColors.goodsOtherGrayColor,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: XCColors.goodsOtherGrayColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 11)
                ],
              ),
            ),
          ],
        ),
      );
    }

    /// 商品列表
    Widget _buildGoodsList() {
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
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(
                          context, DetailScreen(_itemEntityList[index].id),
                          needLogin: false);
                    },
                    child: _goodsItem(index),
                  );
                },
              ),
      );
    }

    /// tab视图
    Widget _buildTabController() {
      int count = widget.children.length > 4 ? 4 : widget.children.length;
      List<TabEntity> tabItems = <TabEntity>[];
      for (int i = 0; i < count; i++) {
        TabEntity entity = widget.children[i];
        tabItems.add(entity);
      }
      return Column(children: <Widget>[
        widget.children.isEmpty
            ? Container()
            : Row(children: [
                Expanded(
                  child: Container(
                    height: 37,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: tabItems.map((e) {
                        return Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              _tapTabItem(e);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: Text(
                                e.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: e.isSelected
                                        ? XCColors.bannerSelectedColor
                                        : XCColors.tabNormalColor,
                                    fontWeight: e.isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      /// 弹窗
                      CategoryDialog.showCategoryDialog(
                          context,
                          widget.children,
                          _bannerEntity.pic.isEmpty,
                          _tapTabItem);
                    },
                    child: Container(
                        width: 35,
                        height: 35,
                        padding: const EdgeInsets.symmetric(horizontal: 11.5),
                        child: Image.asset(
                            'assets/images/home/home_detail_arrow_down.png',
                            width: 12,
                            height: 6)))
              ]),
        Expanded(child: _buildGoodsList())
      ]);
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _bannerEntity.pic.isEmpty
              ? Container()
              : GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => {Tool.openUrl(context, _bannerEntity.url)},
                  child: Container(
                      margin: const EdgeInsets.only(left: 11, right: 14),
                      height: 100,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      child: CommonWidgets.networkImage(_bannerEntity.pic)),
                ),
          Expanded(
            child: _buildTabController(),
          )
        ],
      ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
