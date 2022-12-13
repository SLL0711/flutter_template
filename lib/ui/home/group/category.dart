import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../empty.dart';

class GroupTabScreen extends StatefulWidget {
  final int type;
  final ScreeningParams screeningParams;

  GroupTabScreen(this.type, this.screeningParams);

  @override
  State<StatefulWidget> createState() => GroupTabScreenState();
}

class GroupTabScreenState extends State<GroupTabScreen>
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
      init();
    });
  }

  void init() {
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
    params['pageSize'] = '10';
    // 拼团
    params['groupFlag'] = '1';

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
    if (groupFlag != 0) {
      params['groupFlag'] = groupFlag.toString();
    }

    print('=====params==$params');
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
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _goodsItem(int index) {
      ProductItemEntity item = _itemEntityList[index];
      return Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: XCColors.bannerShadowColor, blurRadius: 7)
        ], color: Colors.white),
        child: Row(
          children: [
            Container(
              width: 82,
              height: 82,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: CommonWidgets.networkImage(item.pic),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: XCColors.mainTextColor,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(children: [
                    Container(
                      width: 48,
                      alignment: Alignment.center,
                      height: 16,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/home/home_group_bg.png'),
                          alignment: Alignment.topCenter,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Text(
                        '${item.groupMemberNum}人团',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '还差${item.groupMemberNum - 1}人成团',
                      style: TextStyle(
                        color: XCColors.tabNormalColor,
                        fontSize: 12,
                      ),
                    ),
                  ]),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '¥${item.groupTotalPrice}',
                        style: TextStyle(
                          color: XCColors.themeColor,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        '¥${item.price}',
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: XCColors.tabNormalColor,
                          color: XCColors.tabNormalColor,
                          fontSize: 12,
                        ),
                      ),
                      Expanded(child: Container()),
                      Container(
                        width: 75,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          color: XCColors.bannerSelectedColor,
                        ),
                        child: Text(
                          '去拼团',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return _itemEntityList.isEmpty
        ? Container(height: 350, child: EmptyWidgets.dataEmptyView(context))
        : ListView.builder(
            itemCount: _itemEntityList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {},
                  child: _goodsItem(index));
            });
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
