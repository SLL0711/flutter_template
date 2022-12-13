import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/diary_detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../event_center.dart';

class CollectionDiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CollectionDiaryScreenState();
}

class CollectionDiaryScreenState extends State<CollectionDiaryScreen>
    with AutomaticKeepAliveClientMixin {
  /// 变量
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  var _refreshEvent;
  List<DiaryItemEntity> _itemEntityList = <DiaryItemEntity>[];
  int _currentPage = 1;

  @override
  void dispose() {
    _refreshController.dispose();
    _refreshEvent.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _refreshEvent = EventCenter.defaultCenter()
        .on<RefreshCollectionEvent>()
        .listen((event) {
      _currentPage = 1;
      _requestInfo(0);
    });
    Future.delayed(Duration.zero, () {
      _requestInfo(0);
    });
    super.initState();
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = 20;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.collectList + '1', context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DiaryEntity entity = DiaryEntity.fromJson(http.data['diaryBooks']);
      if (_currentPage == 1) {
        _itemEntityList.clear();
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
    _requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestInfo(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      header: MaterialClassicHeader(),
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      footer: CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
        return HomeWidgets.homeRefresherFooter(context, mode);
      }),
      child: Column(
        children: [
          Container(
              height: 10,
              width: double.infinity,
              color: XCColors.homeDividerColor),
          Expanded(
            child: _itemEntityList.isEmpty
                ? EmptyWidgets.dataEmptyView(context)
                : ListView.builder(
                    itemCount: _itemEntityList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          NavigatorUtil.pushPage(context,
                              DiaryDetailScreen(_itemEntityList[index].id),
                              needLogin: false);
                        },
                        child: FootprintWidgets.diaryItem(
                          context,
                          _itemEntityList[index],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
