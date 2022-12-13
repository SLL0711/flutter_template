import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/diary_detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../colors.dart';
import '../../widgets.dart';

class OrgCaseView extends StatefulWidget {
  final int id;

  OrgCaseView(this.id);

  @override
  State<StatefulWidget> createState() => OrgCaseViewState();
}

class OrgCaseViewState extends State<OrgCaseView>
    with AutomaticKeepAliveClientMixin {
  List<DoctorProjectEntity> _categoryList = <DoctorProjectEntity>[];
  int _categoryId = 0;
  int _currentPage = 1;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<DiaryItemEntity> _itemEntityList = <DiaryItemEntity>[];
  bool _isGrounding = false;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, _init);
    super.initState();
  }

  void _init() async {
    _isGrounding = await Tool.isGrounding();
    _requestCategoryInfo();
  }

  void _requestCategoryInfo() async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = '1';
    params['pageSize'] = '20';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.diaryCategory, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        if (http.data['list'] != null) {
          setState(() {
            http.data['list'].forEach((element) {
              DoctorProjectEntity entity =
                  DoctorProjectEntity.fromJson(element);
              _categoryList.add(entity);
            });

            if (_categoryList.isNotEmpty) {
              DoctorProjectEntity entity = _categoryList.first;
              entity.isSelected = true;
              _categoryId = entity.categoryId;
              _requestInfo(0);
            }
          });
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['categoryId'] = _categoryId;
    params['orgId'] = widget.id;

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

    Widget _buildHeader() {
      return Container(
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child: _categoryList.isEmpty
              ? Container()
              : Wrap(
                  spacing: 20,
                  runSpacing: 15,
                  alignment: WrapAlignment.start,
                  children: _categoryList.map((e) {
                    return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _categoryId = e.categoryId;
                          _currentPage = 1;
                          _requestInfo(0);

                          setState(() {
                            _categoryList.forEach((element) {
                              element.isSelected = false;
                            });
                            e.isSelected = true;
                          });
                        },
                        child: Container(
                            height: 25,
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 4),
                            decoration: BoxDecoration(
                                color: e.isSelected
                                    ? XCColors.bannerSelectedColor
                                    : XCColors.bannerHintColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.5))),
                            child: Text('${e.categoryName} ${e.count}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: e.isSelected
                                        ? Colors.white
                                        : XCColors.mainTextColor))));
                  }).toList()));
    }

    return Scaffold(
        backgroundColor: XCColors.homeDividerColor,
        appBar: CityWidgets.cityAppBar(
          context,
          _isGrounding ? '技师的案例' : '咨询师的案例',
          () {
            Navigator.pop(context);
          },
        ),
        body: Column(children: [
          _buildHeader(),
          Expanded(
              child: _itemEntityList.isEmpty
                  ? EmptyWidgets.dataEmptyView(context)
                  : SmartRefresher(
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
                          itemCount: _itemEntityList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  NavigatorUtil.pushPage(
                                      context,
                                      DiaryDetailScreen(
                                          _itemEntityList[index].id),
                                      needLogin: false);
                                },
                                child: FootprintWidgets.diaryItem(
                                    context, _itemEntityList[index]));
                          })))
        ]));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
