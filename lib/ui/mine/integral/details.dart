import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/gold/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../api.dart';
import '../../../colors.dart';
import '../../../empty.dart';
import '../../../http.dart';
import '../../../toast.dart';

class DetailsScreen extends StatefulWidget {
  final int type;

  DetailsScreen(this.type);

  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

class DetailsScreenState extends State<DetailsScreen>
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
      init(1);
    });
  }

  void init(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = 10;
    if (widget.type == 1) {
      // 积分明细
      params['changeType'] = 3;
    }

    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.beautyBalanceList,
      context,
      params: params,
    );
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
        child: Row(
          children: [
            /*Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: CommonWidgets.networkImage(itemEntity.icon),
            ),*/
            SizedBox(width: 7),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /*Text(
                    itemEntity.nickName,
                    style: TextStyle(
                      fontSize: 14,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: 5),*/
                  Text(
                    itemEntity.remark,
                    style: TextStyle(
                      fontSize: 16,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    itemEntity.createTime,
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.goldTimeColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Text(
              itemEntity.changeType == 0
                  ? '+${itemEntity.beautyBalance}'
                  : '-${itemEntity.beautyBalance}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: itemEntity.changeType == 0
                    ? XCColors.goldInColor
                    : XCColors.goldOutColor,
              ),
            ),
            SizedBox(width: 5),
            Text(
              widget.type == 1 ? '元' : '积分',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      );
    }

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
                return _item(_itemEntityList[index]);
              },
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
