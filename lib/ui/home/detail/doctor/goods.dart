import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../colors.dart';
import '../../../../tool.dart';
import '../../widgets.dart';

class DoctorGoodsView extends StatefulWidget {
  final int id;

  DoctorGoodsView(this.id);

  @override
  State<StatefulWidget> createState() => DoctorGoodsViewState();
}

class DoctorGoodsViewState extends State<DoctorGoodsView>
    with AutomaticKeepAliveClientMixin {
  DoctorGoodsTopEntity _topEntity = DoctorGoodsTopEntity();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductItemEntity> _itemEntityList = <ProductItemEntity>[];
  int _currentPage = 1;
  int _categoryId = 0;
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
    _requestGoodsInfo();
  }

  void _requestGoodsInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '20';

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.doctorGoodsTop + widget.id.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _topEntity = DoctorGoodsTopEntity.fromJson(http.data);
        if (_topEntity.productCategoryVOS.list.isNotEmpty) {
          _topEntity.productCategoryVOS.list.first.isSelected = true;
          _categoryId = _topEntity.productCategoryVOS.list.first.categoryId;
          _requestInfo(0);
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['categoryId'] = _categoryId;
    params['latitude'] = await Tool.getString('latitude');
    params['longitude'] = await Tool.getString('longitude');

    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.doctorGoods + widget.id.toString(),
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      if (_currentPage == 1) {
        _itemEntityList.clear();
      }
      _currentPage++;
      ProductEntity entity = ProductEntity.fromJson(http.data);
      setState(() {
        _itemEntityList.addAll(entity.list);
        if (type == 1) {
          _refreshController.refreshCompleted();
        } else if (type == 2) {
          _refreshController.loadComplete();
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

    Widget _buildHeader() {
      return Container(
          color: Colors.white,
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            RichText(
                text: TextSpan(
                    text: '商品总数： ',
                    style:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                    children: [
                  TextSpan(
                      text: _topEntity.productNum.toString(),
                      style: TextStyle(
                          fontSize: 12, color: XCColors.bannerSelectedColor)),
                  TextSpan(
                      text: ' ，总预约数： ',
                      style: TextStyle(
                          fontSize: 12, color: XCColors.tabNormalColor)),
                  TextSpan(
                      text: _topEntity.reserveNum.toString(),
                      style: TextStyle(
                          fontSize: 12, color: XCColors.bannerSelectedColor))
                ])),
            SizedBox(height: 10),
            _topEntity.productCategoryVOS.list.isEmpty
                ? Container()
                : Wrap(
                    spacing: 20,
                    runSpacing: 15,
                    alignment: WrapAlignment.start,
                    children: _topEntity.productCategoryVOS.list.map((e) {
                      return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _categoryId = e.categoryId;
                            _currentPage = 1;
                            _requestInfo(0);

                            setState(() {
                              _topEntity.productCategoryVOS.list
                                  .forEach((element) {
                                element.isSelected = false;
                              });
                              e.isSelected = true;
                            });
                          },
                          child: Container(
                              height: 25,
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 4),
                              decoration: BoxDecoration(
                                  color: e.isSelected
                                      ? XCColors.bannerSelectedColor
                                      : XCColors.bannerHintColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.5))),
                              child: Text('${e.name} ${e.num}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: e.isSelected
                                          ? Colors.white
                                          : XCColors.mainTextColor))));
                    }).toList())
          ]));
    }

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
                        Text(
                          '¥${itemEntity.minPrice}',
                          style: TextStyle(
                            color: XCColors.themeColor,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 3),
                        Text('￥${itemEntity.price}',
                            style: TextStyle(
                                color: XCColors.goodsOtherGrayColor,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: XCColors.goodsOtherGrayColor,
                                fontSize: 12)),
                        Expanded(
                            child: Text('已售 ${itemEntity.sale}',
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
        appBar: CityWidgets.cityAppBar(
          context,
          _isGrounding ? '技师的商品列表' : '咨询师的商品列表',
          () {
            Navigator.pop(context);
          },
        ),
        body: Column(children: [
          _buildHeader(),
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
