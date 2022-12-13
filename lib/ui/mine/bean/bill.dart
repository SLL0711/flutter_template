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

class BeanBillScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BeanBillScreenState();
}

class BeanBillScreenState extends State<BeanBillScreen>
    with AutomaticKeepAliveClientMixin {
  // List<GoldInfoItemEntity> _itemEntityList = <GoldInfoItemEntity>[];
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

    // Future.delayed(Duration.zero, () {
    //   init(0);
    // });
  }

  // void init(int type) async {
  //   Map<String, String> params = Map();
  //   params['pageNum'] = '$_currentPage';
  //   params['pageSize'] = '10';
  //   // params['type'] = '${widget.type}';
  //
  //   ToastHud.loading(context);
  //   var http =
  //   await HttpManager.get(DsApi.beautyBalanceList, context, params: params);
  //   ToastHud.dismiss();
  //   if (http.code == 200) {
  //     GoldInfoEntity goldInfoEntity = GoldInfoEntity.fromJson(http.data);
  //
  //     if (_currentPage == 1) {
  //       _itemEntityList = <GoldInfoItemEntity>[];
  //     }
  //
  //     if (type == 1) {
  //       _refreshController.refreshCompleted();
  //     }
  //     _currentPage++;
  //     setState(() {
  //       _itemEntityList.addAll(goldInfoEntity.list);
  //       if (type == 2) {
  //         if (goldInfoEntity.total == _itemEntityList.length) {
  //           _refreshController.loadNoData();
  //         } else {
  //           _refreshController.loadComplete();
  //         }
  //       }
  //     });
  //   } else {
  //     ToastHud.show(context, http.message!);
  //     if (type == 1) {
  //       _refreshController.refreshFailed();
  //     } else if (type == 2) {
  //       _refreshController.loadFailed();
  //     }
  //   }
  // }

  void _onLoading() {
    // init(2);
    _refreshController.loadNoData();
  }

  void _onRefresh() {
    // _currentPage = 1;
    // init(1);
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _item(int index) {
      return Container(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child: Row(children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text('兑换商品-德国精油spa按摩60分…',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 14, color: XCColors.mainTextColor)),
                  SizedBox(height: 5),
                  Text('2019-08-08',
                      style: TextStyle(
                          fontSize: 10, color: XCColors.goodsGrayColor))
                ])),
            SizedBox(width: 10),
            Text(index != 0 ? '+100' : '-300',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: index != 0
                        ? XCColors.goldInColor
                        : XCColors.goldOutColor))
          ]));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(context, '颜值豆明细', () {
          Navigator.pop(context);
        }),
        body: SmartRefresher(
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
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _item(index);
                })));
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
