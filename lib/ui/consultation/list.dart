import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/consultation/detail.dart';
import 'package:flutter_medical_beauty/ui/consultation/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/video/video_detail.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../colors.dart';
import '../../event_center.dart';

class ConsultationListView extends StatefulWidget {
  final int index, sort, filter;

  ConsultationListView(this.index, this.sort, this.filter);

  @override
  State<StatefulWidget> createState() => ConsultationListViewState();
}

class ConsultationListViewState extends State<ConsultationListView>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<DoctorItemEntity> _itemEntityList = <DoctorItemEntity>[];
  int _currentPage = 1, _sort = -1, _filter = -1;
  var _refreshEvent;

  @override
  void dispose() {
    _refreshController.dispose();
    _refreshEvent.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _refreshEvent = EventCenter.defaultCenter()
        .on<RefreshConsultEvent>()
        .listen((RefreshConsultEvent event) {
      if (event.type == 1) {
        _filter = event.value;
        _currentPage = 1;
        _init();
      } else {
        _sort = event.value;
        _currentPage = 1;
        _init();
      }
    });
    _sort = widget.sort;
    _filter = widget.filter;
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() {
    _requestInfo(0);
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['productCategoryIId'] = widget.index;
    if (_sort != -1) {
      params['sort'] = _sort + 1;
    }
    if (_filter != -1) {
      params['consultStatus'] = 3 - _filter;
    }

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.videoList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DoctorEntity entity = DoctorEntity.fromJson(http.data);
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

    Widget _buildItem(DoctorItemEntity entity) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: XCColors.homeDividerColor,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 88,
                height: 88,
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(44)),
                child: entity.avatar.isEmpty
                    ? Image.asset('assets/images/mine/mine_avatar.png')
                    : CommonWidgets.networkImage(entity.avatar)),
            SizedBox(width: 15),
            Expanded(
                child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          entity.name,
                          style: TextStyle(
                            fontSize: 14,
                            color: XCColors.mainTextColor,
                          ),
                        ),
                        SizedBox(width: 13),
                        Container(
                          height: 14,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: XCColors.mainTextColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            entity.duties,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      '擅长：${entity.beGoodAtProjectName}等${entity.beGoodAtProjectCount}项目',
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ConsultationWidgets.scoreStar(
                                context,
                                entity.score,
                              ),
                              SizedBox(width: 5),
                              Text(
                                entity.score.toString(),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: XCColors.mainTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 20,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(
                              color: XCColors.mainTextColor,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/video/ic_consultation.png',
                                width: 18,
                                height: 11,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '咨询',
                                style: TextStyle(
                                  color: XCColors.mainTextColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Positioned(
                  top: 5,
                  right: 0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/video/ic_heart.png',
                        width: 16,
                        height: 15,
                      ),
                      SizedBox(width: 3),
                      Text(
                        '${entity.likeNumber}',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.mainTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )),
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
      footer: CustomFooter(builder: (BuildContext context, LoadStatus? mode) {
        return HomeWidgets.homeRefresherFooter(context, mode);
      }),
      child: _itemEntityList.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : ListView.builder(
              itemCount: _itemEntityList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    /// 跳转消息详情
                    NavigatorUtil.pushPage(
                      context,
                      ConsultantDetailScreen(
                        widget.index,
                        _itemEntityList[index].id,
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 5.0 : 0.0,
                    ),
                    color: Colors.white,
                    child: _buildItem(_itemEntityList[index]),
                  ),
                );
              },
            ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
