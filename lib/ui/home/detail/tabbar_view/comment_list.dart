import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CommentListScreen extends StatefulWidget {
  final int doctorId;
  final String doctorName;

  CommentListScreen(this.doctorId, this.doctorName);

  @override
  State<StatefulWidget> createState() => CommentListScreenState();
}

class CommentListScreenState extends State<CommentListScreen>
    with AutomaticKeepAliveClientMixin {
  List<CommentItemEntity> _commentList = <CommentItemEntity>[];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _currentPage = 1;
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
    _requestCommentInfo(0);
  }

  void _requestCommentInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['pageNum'] = _currentPage;
    params['pageSize'] = '10';
    params['doctorId'] = widget.doctorId;
    params['name'] = widget.doctorName;

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.doctorCommentList + widget.doctorId.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      CommentEntity entity = CommentEntity.fromJson(http.data);
      if (_currentPage == 1) {
        _commentList.clear();
      }
      _currentPage++;
      setState(() {
        _commentList.addAll(entity.list);
        if (type == 1) {
          _refreshController.refreshCompleted();
        } else if (type == 2) {
          if (entity.total == _commentList.length) {
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

    Widget _item(
        String title, String image, double imageWidth, double imageHeight) {
      return Row(children: [
        Image.asset(image, width: imageWidth, height: imageHeight),
        SizedBox(width: 3),
        Text(title,
            style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
      ]);
    }

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(
        context,
        '评价',
        () {
          Navigator.pop(context);
        },
      ),
      body: _commentList.isEmpty
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
                itemCount: _commentList.length,
                itemBuilder: (context, index) {
                  CommentItemEntity itemEntity = _commentList[index];
                  return Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          width: 1,
                          color: XCColors.homeDividerColor,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: CommonWidgets.networkImage(
                            itemEntity.memberIcon,
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(itemEntity.memberNickName,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: XCColors.mainTextColor)),
                                      SizedBox(height: 5),
                                      CommonWidgets.scoreWidget(
                                          itemEntity.totalScore)
                                    ]),
                                Expanded(
                                    child: Text(itemEntity.createTime,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: XCColors.goodsGrayColor)))
                              ]),
                              SizedBox(height: 10),
                              Text(itemEntity.content,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: XCColors.mainTextColor)),
                              SizedBox(height: 13),
                              Row(
                                children: [
                                  _item(
                                      '${itemEntity.readCount}',
                                      'assets/images/home/home_detail_diary_reading.png',
                                      16,
                                      9),
                                  SizedBox(width: 15),
                                  _item(
                                    '${itemEntity.praiseCount}',
                                    itemEntity.praiseFlag == 0
                                        ? 'assets/images/home/home_detail_diary_like_normal.png'
                                        : 'assets/images/home/home_detail_diary_like_selected.png',
                                    17,
                                    17,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
