import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class GoldInfoCategoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GoldInfoCategoryScreenState();
}

class GoldInfoCategoryScreenState extends State<GoldInfoCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  List<GoldInfoItemEntity> _itemEntityList = <GoldInfoItemEntity>[];
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  // GoldInfoEntity
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
    // params['type'] = '${widget.type}';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.beautyBalanceList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      GoldInfoEntity goldInfoEntity = GoldInfoEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _itemEntityList = <GoldInfoItemEntity>[];
      }

      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      _currentPage++;
      setState(() {
        _itemEntityList.addAll(goldInfoEntity.list);
        if (type == 2) {
          if (goldInfoEntity.total == _itemEntityList.length) {
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

    Widget _item(GoldInfoItemEntity itemEntity) {
      return Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child: Row(children: [
            Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.all(Radius.circular(25)))),
            SizedBox(width: 7),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(itemEntity.nickName,
                      style: TextStyle(
                          fontSize: 14, color: XCColors.mainTextColor)),
                  SizedBox(height: 5),
                  Text(itemEntity.remark,
                      style: TextStyle(
                          fontSize: 12, color: XCColors.goldContentColor)),
                  SizedBox(height: 8),
                  Text(itemEntity.createTime,
                      style: TextStyle(
                          fontSize: 10, color: XCColors.goldTimeColor))
                ])),
            SizedBox(width: 10),
            Text(
                itemEntity.changeType == 0
                    ? '+¥${itemEntity.beautyBalance}'
                    : '-¥${itemEntity.beautyBalance}',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: itemEntity.changeType == 0
                        ? XCColors.goldInColor
                        : XCColors.goldOutColor))
            // Column(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       SizedBox(height: 25),
            //       Text(itemEntity.changeType == 0 ? '+¥${itemEntity.beautyBalance}' : '-¥${itemEntity.beautyBalance}',
            //           style: TextStyle(
            //               fontSize: 18,
            //               fontWeight: FontWeight.bold,
            //               color: XCColors.goldInColor)),
            //       SizedBox(height: 3),
            //       Text('待入账',
            //           style:
            //               TextStyle(fontSize: 10, color: XCColors.goldInColor))
            //     ])
          ]));
    }

    return _itemEntityList.isEmpty
        ? EmptyWidgets.dataEmptyView(context)
        : SmartRefresher(
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
            child: ListView.builder(
                itemCount: _itemEntityList.length,
                itemBuilder: (context, index) {
                  return _item(_itemEntityList[index]);
                }));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
