import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/comment_detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../widgets.dart';
import '../widgets.dart';

class DetailCommentView extends StatefulWidget {
  final int id;

  DetailCommentView(this.id);

  @override
  State<StatefulWidget> createState() => DetailCommentViewState();
}

class DetailCommentViewState extends State<DetailCommentView>
    with AutomaticKeepAliveClientMixin {
  CommentInfoEntity _infoEntity = CommentInfoEntity();
  List _tabList = [
    {'city': '全部'},
    {'city': '有图'},
    {'city': '好评'},
    {'city': '差评'}
  ];
  List<HomeDistanceEntity> _tabEntityList = <HomeDistanceEntity>[];
  int _categoryId = 0;
  int _currentPage = 1;
  List<CommentItemEntity> _itemEntityList = <CommentItemEntity>[];
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

    // 筛选初始化
    _tabEntityList = _tabList.map((value) {
      return HomeDistanceEntity.fromJson(value);
    }).toList();

    Future.delayed(Duration.zero, () {
      _requestInfo(0);
    });
  }

  void _requestInfo(int type) async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.commentBasicInfo + widget.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _infoEntity = CommentInfoEntity.fromJson(http.data);
        for (int i = 0; i < _tabEntityList.length; i++) {
          HomeDistanceEntity element = _tabEntityList[i];
          if (i == 0) {
            element.city = '全部 ${_infoEntity.total}';
            element.isSelected = true;
            _categoryId = 0;
          } else if (i == 1) {
            element.city = '有图 ${_infoEntity.iconNum}';
          } else if (i == 2) {
            element.city = '好评 ${_infoEntity.goodNum}';
          } else if (i == 3) {
            element.city = '差评 ${_infoEntity.poorNum}';
          }
        }
        _requestCommentInfo(0);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _tapFlagAction(int index) {
    _categoryId = index;

    setState(() {
      _tabEntityList.forEach((element) {
        element.isSelected = false;
      });
      HomeDistanceEntity entity = _tabEntityList[index];
      entity.isSelected = true;
    });

    _currentPage = 1;
    _requestCommentInfo(0);
  }

  void _requestCommentInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['filter'] = _categoryId;
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['productId'] = widget.id.toString();

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.commentList + widget.id.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      CommentEntity entity = CommentEntity.fromJson(http.data);

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
    _requestCommentInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestCommentInfo(1);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      height: double.infinity,
      child: Column(
        children: [
          Expanded(
            child: SmartRefresher(
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
              child: CustomScrollView(
                slivers: [
                  // 如果不是Sliver家族的Widget，需要使用SliverToBoxAdapter做层包裹
                  SliverToBoxAdapter(
                    child: DetailWidgets.commentHeaderView(
                      context,
                      _infoEntity,
                      _tabEntityList,
                      _tapFlagAction,
                    ),
                  ),
                  // 当列表项高度固定时，使用 SliverFixedExtendList 比 SliverList 具有更高的性能
                  // SliverFixedExtentList(
                  //     delegate: SliverChildBuilderDelegate(_buildListItem, childCount: 18),
                  //     itemExtent: 48.0),
                  _itemEntityList.isEmpty
                      ? SliverToBoxAdapter(
                          child: EmptyWidgets.dataEmptyView(context))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  NavigatorUtil.pushPage(
                                    context,
                                    CommentDetailView(
                                      _itemEntityList[index].id,
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    _itemEntityList[index].hasPic == 1
                                        ? DetailWidgets.commentWithImageItem(
                                            context, _itemEntityList[index])
                                        : DetailWidgets.commentItem(
                                            context, _itemEntityList[index]),
                                    Container(
                                        height: 1,
                                        color: XCColors.homeDividerColor)
                                  ],
                                ),
                              );
                            },
                            childCount: _itemEntityList.length,
                          ),
                        ),
                ],
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
