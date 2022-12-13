import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/event_center.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/detail.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/edit.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'create.dart';

class DiaryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DiaryScreenState();
}

class DiaryScreenState extends State<DiaryScreen>
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
    _refreshEvent =
        EventCenter.defaultCenter().on<RefreshDiaryEvent>().listen((event) {
      _currentPage = 1;
      init(0);
    });
    Future.delayed(Duration.zero, () {
      init(0);
    });
    super.initState();
  }

  void init(int type) async {
    Map<String, String> params = Map();
    params['pageNum'] = '$_currentPage';
    params['pageSize'] = '10';

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.diaryList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DiaryEntity entity = DiaryEntity.fromJson(http.data);

      if (_currentPage == 1) {
        _itemEntityList.clear();
      }

      _currentPage++;
      if (type == 1) {
        _refreshController.refreshCompleted();
      }
      setState(() {
        _itemEntityList.addAll(entity.list);
        if (type == 2) {
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
    init(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    init(1);
  }

  void _menuTapAction(int type, int id, int num) {
    if (type == 1) {
      Navigator.push(context,
              CupertinoPageRoute(builder: (ctx) => DiaryEditScreen(id)))
          .then((value) {
        if (value == null) return;
        if (value == '1') {
          _currentPage = 1;
          init(1);
        }
      });
    } else {
      _deleteAction(id, num);
    }
  }

  void _deleteAction(int id, int num) async {
    Map<String, dynamic> params = Map();
    params['diaryId'] = id;

    ToastHud.loading(context);
    var http = await HttpManager.delete(DsApi.deleteDiaryBook, context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '删除成功');
      setState(() {
        _itemEntityList.removeAt(num);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '我的日记', () {
        Navigator.pop(context);
      }),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 10),
                Expanded(
                  child: SmartRefresher(
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
                              DiaryItemEntity itemEntity =
                                  _itemEntityList[index];
                              return DiaryWidgets.diaryItem(
                                context,
                                itemEntity,
                                (i) {
                                  _menuTapAction(i, itemEntity.id, index);
                                },
                                () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (ctx) => DiaryBookDetailScreen(
                                        itemEntity.id,
                                        isOwner: true,
                                      ),
                                    ),
                                  ).then(
                                    (value) {
                                      if (value == null) return;
                                      if (value == '1') {
                                        _currentPage = 1;
                                        init(1);
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 95,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DiaryCreateScreen(),
                  ),
                ).then(
                  (value) {
                    if (value == null) return;
                    if (value == '1') {
                      _currentPage = 1;
                      init(0);
                    }
                  },
                );
              },
              child: Container(
                width: 56,
                height: 56,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(28)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter, //右上
                    end: Alignment.topCenter, //左下
                    stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                    //渐变颜色[始点颜色, 结束颜色]
                    colors: [XCColors.themeColor, Color(0XFFAFEAFD)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: XCColors.themeColor,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '+',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        height: 0.6,
                      ),
                    ),
                    Text(
                      '日记本',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
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
