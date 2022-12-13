import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/video/video_detail.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../colors.dart';

class VideoListView extends StatefulWidget {
  final int index;

  VideoListView(this.index);

  @override
  State<StatefulWidget> createState() => VideoListViewState();
}

class VideoListViewState extends State<VideoListView>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<DoctorItemEntity> _itemEntityList = <DoctorItemEntity>[];
  int _currentPage = 1;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _init);
  }

  void _init() {
    _requestInfo(0);
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['productCategoryIId'] = widget.index;

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
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(
          left: 14,
          right: 14,
          top: 15,
          bottom: 15,
        ),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: 52,
                height: 52,
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(24)),
                child: entity.avatar.isEmpty
                    ? Image.asset('assets/images/mine/mine_avatar.png')
                    : CommonWidgets.networkImage(entity.avatar)),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        entity.name,
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                        ),
                      ),
                      SizedBox(width: 13),
                      Container(
                        height: 12,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft, //右上
                            end: Alignment.centerRight, //左下
                            stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                            //渐变颜色[始点颜色, 结束颜色]
                            colors: [Color(0xFFF2A664), Color(0xFFFAD29D)],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entity.duties,
                          style: TextStyle(
                            fontSize: 7,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 7),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/video/video_star.png',
                        width: 89,
                        height: 14,
                      ),
                      SizedBox(width: 13),
                      Container(
                        width: 1,
                        height: 8,
                        color: Color(0xFFDDDEDD),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '咨询数${entity.consultNum}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        width: 1,
                        height: 8,
                        color: Color(0xFFDDDEDD),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '关注数${entity.likeNumber}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '咨询师标签',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black38,
                        ),
                      ),
                      SizedBox(width: 10),
                      Wrap(
                        spacing: 5,
                        runSpacing: 5,
                        alignment: WrapAlignment.start,
                        children: List.generate(
                          entity.tagList.length,
                          (index) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 2,
                                horizontal: 5,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: XCColors.homeDividerColor,
                              ),
                              child: Text(
                                entity.tagList[index].tagName,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF999999),
                                ),
                              ),
                            );
                          },
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
                      VideoDetailScreen(
                        widget.index,
                        _itemEntityList[index].id,
                      ),
                    );
                  },
                  child: _buildItem(_itemEntityList[index]),
                );
              },
            ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
