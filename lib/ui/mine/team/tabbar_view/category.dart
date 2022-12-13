import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets.dart';

class TeamCategoryView extends StatefulWidget {
  final int type;

  TeamCategoryView(this.type);

  @override
  State<StatefulWidget> createState() => TeamCategoryViewState();
}

class TeamCategoryViewState extends State<TeamCategoryView>
    with AutomaticKeepAliveClientMixin {
  List<TeamItemEntity> _itemEntityList = <TeamItemEntity>[];
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
    var http = await HttpManager.get(DsApi.teamInfo, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      TeamEntity teamEntity = TeamEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _itemEntityList = <TeamItemEntity>[];
      }

      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      _currentPage++;
      setState(() {
        _itemEntityList.addAll(teamEntity.vos.list);
        if (type == 2) {
          if (teamEntity.vos.total == _itemEntityList.length) {
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
                return TeamWidgets.teamItemView(
                    context, _itemEntityList[index]);
              },
            ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
