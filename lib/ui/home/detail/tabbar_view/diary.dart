import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/diary_detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widgets.dart';

class DetailDiaryView extends StatefulWidget {
  final int id;

  DetailDiaryView(this.id);

  @override
  State<StatefulWidget> createState() => DetailDiaryViewState();
}

class DetailDiaryViewState extends State<DetailDiaryView>
    with AutomaticKeepAliveClientMixin {
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<DiaryItemEntity> _itemEntityList = <DiaryItemEntity>[];

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestInfo(0);
    });
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['productId'] = widget.id;

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.diaryList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DiaryEntity entity = DiaryEntity.fromJson(http.data);
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

    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: _itemEntityList.isEmpty
                ? EmptyWidgets.dataEmptyView(context)
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullDown: false,
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
                        return Column(
                          children: [
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                NavigatorUtil.pushPage(
                                  context,
                                  DiaryBookDetailScreen(
                                      _itemEntityList[index].id),
                                );
                              },
                              child: FootprintWidgets.diaryItem(
                                context,
                                _itemEntityList[index],
                              ),
                            ),
                            Container(
                              height: 1,
                              color: XCColors.homeDividerColor,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
          SizedBox(height: 80),
        ],
      ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
