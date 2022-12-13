import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/common/preview.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/dialog.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../navigator.dart';
import '../widgets.dart';

class CommentDetailView extends StatefulWidget {
  final int commentId;

  CommentDetailView(this.commentId);

  @override
  State<StatefulWidget> createState() => CommentDetailViewState();
}

class CommentDetailViewState extends State<CommentDetailView>
    with AutomaticKeepAliveClientMixin {
  CommentItemEntity _detailEntity = CommentItemEntity();
  int _currentPage = 1;
  int _total = 0;
  RefreshController _refreshController = RefreshController();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  List<CommentItemEntity> _commentList = <CommentItemEntity>[];
  int _selectedCommentId = 0;

  @override
  void dispose() {
    _refreshController.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _selectedCommentId = widget.commentId;
    Future.delayed(Duration.zero, () {
      _requestDetailInfo();

      _requestInfo(0);
    });
  }

  void _requestDetailInfo() async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.commentDetails + widget.commentId.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _detailEntity = CommentItemEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestInfo(int type) async {
    Map<String, dynamic> params = Map();
    params['commentId'] = widget.commentId;
    params['pageNum'] = _currentPage;
    params['pageSize'] = 10;
    params['isFirst'] = 1;

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.commentDetailList + widget.commentId.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      CommentEntity entity = CommentEntity.fromJson(http.data);
      if (_currentPage == 1) {
        _commentList.clear();
      }
      _currentPage++;
      setState(() {
        _total = entity.total;
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
    _requestInfo(2);
  }

  void _onRefresh() {
    _currentPage = 1;
    _requestInfo(1);
  }

  void _commentPraise(CommentItemEntity entity) async {
    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.commentPraise + entity.id.toString(), context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
      setState(() {
        entity.praiseFlag = entity.praiseFlag == 1 ? 0 : 1;
        entity.praiseCount = entity.praiseFlag == 0
            ? entity.praiseCount - 1
            : entity.praiseCount + 1;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _replyDialogAction(int type) {
    // 1 回复, 2 举报 ，3 删除
    if (type == 1) {
      _textEditingController.clear();
      Future.delayed(Duration(milliseconds: 200)).then((e) {
        ReplyDialog.showComment(
            context, _textEditingController, _focusNode, _sendAction);
      });
    } else if (type == 2) {
      _reportAction();
    } else if (type == 3) {}
  }

  /// 回复评论
  void _replyAction(CommentItemEntity entity) {
    _selectedCommentId = entity.id;
    ReplyDialog.show(context, entity.memberNickName + '：' + entity.content,
        _replyDialogAction);
  }

  /// 回复子评论
  void _replyChildAction(CommentChildItemEntity childItemEntity) {
    // _selectedCommentChildId = childItemEntity.id;
    // ReplyDialog.show(
    //     context,
    //     childItemEntity.memberNickName + '：' + childItemEntity.content, true, _replyDialogAction);
  }

  void _moreAction(CommentItemEntity itemEntity) async {
    Map<String, dynamic> params = Map();
    params['commentId'] = widget.commentId;
    params['pageNum'] = itemEntity.currentPage;
    params['pageSize'] = 3;
    params['oneReplayId'] = itemEntity.id;

    ToastHud.loading(context);
    var http = await HttpManager.get(
        DsApi.commentDetailList + widget.commentId.toString(), context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (http.data['list'] != null) {
        itemEntity.currentPage++;
        setState(() {
          http.data['list'].forEach((v) {
            CommentChildItemEntity item = CommentChildItemEntity.fromJson(v);
            itemEntity.childList.add(item);
          });
        });
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _replyContentAction() {
    _textEditingController.clear();
    _selectedCommentId = widget.commentId;
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      ReplyDialog.showComment(
          context, _textEditingController, _focusNode, _sendAction);
    });
  }

  void _reportAction() async {
    Map<String, dynamic> params = Map();
    params['reportObjectId'] = _selectedCommentId;
    params['reportType'] = 1;

    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.report, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _sendAction() async {
    Map<String, dynamic> params = Map();
    params['commentId'] = widget.commentId;
    params['content'] = _textEditingController.text;
    // 上级回复id(一级则不传)
    if (widget.commentId != _selectedCommentId) {
      params['replayId'] = _selectedCommentId;
    }

    print('====params===$params==');
    ToastHud.loading(context);
    var http =
        await HttpManager.post(DsApi.releaseCommentReplay, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
      _currentPage = 1;
      _requestInfo(0);
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _headerInfo() {
      double screenWidth = MediaQuery.of(context).size.width;
      double imageWidth = (screenWidth - 97) / 3.0;
      List<String> images = _detailEntity.pics.split(',');

      return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                    width: 50,
                    height: 50,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child:
                        CommonWidgets.networkImage(_detailEntity.memberIcon)),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(_detailEntity.memberNickName,
                          style: TextStyle(
                              fontSize: 14, color: XCColors.mainTextColor)),
                      SizedBox(height: 5),
                      Text(
                        _detailEntity.createTime,
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabNormalColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _detailEntity.content,
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
            ),
            Container(
              child: MediaQuery.removePadding(
                context: context,
                removeBottom: true,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: images.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                      crossAxisCount: 3,
                      //纵轴间距
                      mainAxisSpacing: 10,
                      //横轴间距
                      crossAxisSpacing: 10,
                      childAspectRatio: 1),
                  itemBuilder: (BuildContext context, int index) {
                    //Widget Function(BuildContext context, int index)
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        NavigatorUtil.pushPage(
                          context,
                          PreviewImagesScreen(images, index),
                        );
                      },
                      child: Container(
                        height: imageWidth,
                        width: imageWidth,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: CommonWidgets.networkImage(images[index]),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    }

    Widget _commentTwoChildView(CommentChildItemEntity childItemEntity) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 20,
            height: 20,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: CommonWidgets.networkImage(
              childItemEntity.memberIcon,
            ),
          ),
          SizedBox(width: 3),
          Text(
            childItemEntity.memberNickName,
            style: TextStyle(
              fontSize: 12,
              color: XCColors.goodsGrayColor,
            ),
          ),
        ]),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 23),
          child: Text(
            childItemEntity.content,
            style: TextStyle(
              fontSize: 14,
              color: XCColors.mainTextColor,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.only(left: 23, bottom: 5),
          child: Text(
            childItemEntity.createTime,
            style: TextStyle(
              fontSize: 11,
              color: XCColors.goodsGrayColor,
            ),
          ),
        ),
      ]);
    }

    Widget _commentChildView(CommentItemEntity entity) {
      return Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom:
                      BorderSide(width: 1, color: XCColors.homeDividerColor))),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Row(children: [
                    Container(
                        width: 30,
                        height: 30,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: CommonWidgets.networkImage(entity.memberIcon)),
                    SizedBox(width: 3),
                    Text(entity.memberNickName,
                        style: TextStyle(
                            fontSize: 12, color: XCColors.goodsGrayColor))
                  ]),
                  SizedBox(height: 5),
                  Container(
                      padding: const EdgeInsets.only(left: 33),
                      child: Text(entity.content,
                          style: TextStyle(
                              fontSize: 14, color: XCColors.mainTextColor))),
                  SizedBox(height: 5),
                  Container(
                      padding: const EdgeInsets.only(left: 33, bottom: 5),
                      child: Text(entity.createTime,
                          style: TextStyle(
                              fontSize: 11, color: XCColors.goodsGrayColor))),
                  Container(
                      padding: const EdgeInsets.only(left: 33, bottom: 5),
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  width: 1, color: XCColors.homeDividerColor))),
                      child: entity.replyNum == 0
                          ? Container()
                          : Column(children: [
                              entity.childList.isEmpty
                                  ? Container()
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          entity.childList.length, (index) {
                                        return GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              _replyChildAction(
                                                  entity.childList[index]);
                                            },
                                            child: _commentTwoChildView(
                                                entity.childList[index]));
                                      })),
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    _moreAction(entity);
                                  },
                                  child: Offstage(
                                      offstage: entity.replyNum ==
                                          entity.childList.length,
                                      child: Container(
                                          height: 30,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  top: BorderSide(
                                                      width: 1,
                                                      color: XCColors
                                                          .homeDividerColor))),
                                          child: Text('查看更多回复',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: XCColors
                                                      .commentBlueColor)))))
                            ]))
                ])),
            SizedBox(width: 13),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  _commentPraise(entity);
                },
                child: Container(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    width: 30,
                    child: Column(children: [
                      Image.asset(
                          entity.praiseFlag == 0
                              ? 'assets/images/home/home_detail_diary_like_normal.png'
                              : 'assets/images/home/home_detail_diary_like_selected.png',
                          width: 21,
                          height: 21),
                      SizedBox(width: 3),
                      Text(entity.praiseCount.toString(),
                          style: TextStyle(
                              fontSize: 14, color: XCColors.tabNormalColor))
                    ])))
          ]));
    }

    Widget _commentView() {
      return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                alignment: Alignment.centerLeft,
                height: 35,
                child: Text('共$_total条评论',
                    style: TextStyle(
                        fontSize: 12, color: XCColors.tabNormalColor))),
            _commentList.isEmpty
                ? Container(
                    height: 300, child: EmptyWidgets.dataEmptyView(context))
                : Column(
                    children: List.generate(_commentList.length, (index) {
                    return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          _replyAction(_commentList[index]);
                        },
                        child: _commentChildView(_commentList[index]));
                  }))
          ]));
    }

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
        appBar: DetailWidgets.detailChildAppBar(context, '评价详情', () {
          Navigator.pop(context);
        }, () {}),
        body: Stack(children: [
          Container(
              height: double.infinity,
              child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: true,
                  onLoading: _onLoading,
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                      child: Column(children: [
                    _headerInfo(),
                    Container(height: 10, color: XCColors.homeDividerColor),
                    _commentView(),
                    Container(height: 20, color: XCColors.homeDividerColor)
                  ])))),
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _replyContentAction,
                  child: Container(
                      height: 50,
                      color: Colors.white,
                      child: Row(children: [
                        SizedBox(width: 15),
                        Expanded(
                            child: Container(
                                height: 35,
                                alignment: Alignment.centerLeft,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    color: XCColors.homeDividerColor,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(17.5))),
                                child: Text('添加一条评论',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: XCColors.tabNormalColor)))),
                        SizedBox(width: 15),
                        _item(
                            '${_detailEntity.readCount}',
                            'assets/images/home/home_detail_diary_reading.png',
                            16,
                            9),
                        SizedBox(width: 15),
                        _item(
                            '${_detailEntity.praiseCount}',
                            true
                                ? 'assets/images/home/home_detail_diary_like_normal.png'
                                : 'assets/images/home/home_detail_diary_like_selected.png',
                            17,
                            17),
                        SizedBox(width: 15),
                        _item(
                            '${_detailEntity.replayCount}',
                            'assets/images/home/home_detail_diary_comment.png',
                            12,
                            12),
                        SizedBox(width: 15)
                      ]))))
        ]));
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
