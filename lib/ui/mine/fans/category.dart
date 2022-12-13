import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/fans/dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FansCategoryView extends StatefulWidget {
  final int type;

  FansCategoryView(this.type);

  @override
  State<StatefulWidget> createState() => FansCategoryViewState();
}

class FansCategoryViewState extends State<FansCategoryView>
    with AutomaticKeepAliveClientMixin {
  List<FansItemEntity> _itemEntityList = <FansItemEntity>[];
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
    params['type'] = '${widget.type}';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.fans, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      FansEntity fansEntity = FansEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _itemEntityList = <FansItemEntity>[];
      }

      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      _currentPage++;
      setState(() {
        _itemEntityList.addAll(fansEntity.list);
        if (type == 2) {
          if (fansEntity.total == _itemEntityList.length) {
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

  void _attentionAction(FansItemEntity itemEntity) async {
    bool isAttention = itemEntity.status == 1;

    Map<String, String> params = Map();
    params['memberId'] = '${itemEntity.id}';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.followOrCancel, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (widget.type == 0) {
        ToastHud.show(context, '取消关注');
        if (_itemEntityList.length == 1) {
          init(0);
        } else {
          setState(() {
            _itemEntityList.remove(itemEntity);
          });
        }
      } else {
        if (isAttention) {
          ToastHud.show(context, '取消关注');
          setState(() {
            itemEntity.status = 0;
          });
        } else {
          ToastHud.show(context, '关注成功');
          setState(() {
            itemEntity.status = 1;
          });
        }
      }
    } else {
      ToastHud.show(context, http.message!);
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

    Widget _fansItem(FansItemEntity itemEntity) {
      bool isAttention = itemEntity.status == 1;
      return Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child: Row(children: [
            Container(
                width: 50,
                height: 50,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25))),
                child: Image.network(
                    'https://img2.baidu.com/it/u=325567737,3478266281&fm=26&fmt=auto&gp=0.jpg',
                    fit: BoxFit.cover)),
            SizedBox(width: 11),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(itemEntity.nickName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16, color: XCColors.mainTextColor)),
                  SizedBox(height: 5),
                  Text(itemEntity.personalizedSignature,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12, color: XCColors.tabNormalColor))
                ])),
            SizedBox(width: 10),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (isAttention) {
                    FansDialog.showFansTip(context, () {
                      _attentionAction(itemEntity);
                    });
                  } else {
                    _attentionAction(itemEntity);
                  }
                },
                child: Container(
                    width: 60,
                    height: 26,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        border: Border.all(
                            width: 1,
                            color: isAttention
                                ? XCColors.bannerSelectedColor
                                : XCColors.goodsGrayColor)),
                    child: Text(isAttention ? '已关注' : '关注',
                        style: TextStyle(
                            fontSize: 12,
                            color: isAttention
                                ? XCColors.bannerSelectedColor
                                : XCColors.goodsGrayColor))))
          ]));
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
                controller: TrackingScrollController(),
                itemCount: _itemEntityList.length,
                itemBuilder: (context, index) {
                  return _fansItem(_itemEntityList[index]);
                }));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
