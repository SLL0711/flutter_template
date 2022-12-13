import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/order/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/order/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class OrderCategoryScreen extends StatefulWidget {
  final int type;

  OrderCategoryScreen(this.type);

  @override
  State<StatefulWidget> createState() => OrderCategoryScreenState();
}

class OrderCategoryScreenState extends State<OrderCategoryScreen>
    with AutomaticKeepAliveClientMixin {
  List<MineOrderEntity> _orderList = <MineOrderEntity>[];
  StreamSubscription? _subscriptionAddress;
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    if (_subscriptionAddress != null) {
      _subscriptionAddress!.cancel();
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.type == 0) {
      _subscriptionAddress =
          EventCenter.defaultCenter().on<RefreshOrderEvent>().listen((event) {
        _currentPage = 1;
        _requestOrderInfo(0);
      });
    }

    Future.delayed(Duration.zero, () {
      _requestOrderInfo(0);
    });
  }

  /// 请求
  void _requestOrderInfo(int type) async {
    // 0待支付 1待使用 2待评价 3待写日记 4已完成
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['status'] = widget.type;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.orderList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      OrderEntity entity = OrderEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _orderList.clear();
      }

      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      _currentPage++;

      setState(() {
        _orderList.addAll(entity.list);
        if (type == 2) {
          if (entity.total == _orderList.length) {
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
    _requestOrderInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestOrderInfo(1);
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
      child: _orderList.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : ListView.builder(
              itemCount: _orderList.length,
              itemBuilder: (context, index) {
                return widget.type == 0
                    ? MineOrderWidgets.payOrderItemWidget(
                        context, _orderList[index])
                    : MineOrderWidgets.useOrderItemWidget(
                        context, widget.type, _orderList[index]);
              },
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
