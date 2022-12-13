import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/dialog.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/dialog.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/home/widgets.dart';
import 'package:flutter_medical_beauty/ui/mine/entity.dart';
import 'package:flutter_medical_beauty/user.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:fluwx/fluwx.dart' as fluwx;

import '../../../../colors.dart';
import '../../../../navigator.dart';
import '../../../../tool.dart';
import '../detail.dart';
import '../entity.dart';

class DiaryDetailScreen extends StatefulWidget {
  final int id;

  DiaryDetailScreen(this.id);

  @override
  State<StatefulWidget> createState() => DiaryDetailScreenState();
}

class DiaryDetailScreenState extends State<DiaryDetailScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  /// 变量
  late TabController _tabController = new TabController(length: 0, vsync: this);
  PageController _pageController = PageController();
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = new FocusNode();
  int _currentImage = 1, _currentPage = 1, _total = 0;
  DiaryDetailEntity _entity = DiaryDetailEntity();
  List<DiaryCommentItemEntity> _commentList = <DiaryCommentItemEntity>[];
  List<ProductItemEntity> _productList = <ProductItemEntity>[];

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _requestDetailInfo();
      _requestGuess();
      _requestInfo();
    });
  }

  void _requestInfo() async {
    Map<String, dynamic> params = Map();
    params['diaryDetailId'] = widget.id;
    params['pageNum'] = _currentPage;
    params['pageSize'] = 10;

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.diaryCommentList, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      DiaryCommentEntity entity = DiaryCommentEntity.fromJson(http.data);
      if (_currentPage == 1) {
        _commentList.clear();
      }
      setState(() {
        _total = entity.total;
        _commentList.addAll(entity.list);
      });
      _currentPage++;
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestGuess() async {
    ToastHud.loading(context);
    Map<String, dynamic> params = Map();
    params['pageNum'] = 1;
    params['pageSize'] = 100;
    params['provinceCode'] = await Tool.getString('provinceCode');
    params['cityCode'] = await Tool.getString('cityCode');
    params['latitude'] = await Tool.getString('latitude');
    params['longitude'] = await Tool.getString('longitude');
    var http =
        await HttpManager.get(DsApi.guessYouLike, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _productList = ProductEntity.fromJson(http.data).list;
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _requestDetailInfo() async {
    Map<String, dynamic> params = Map();
    params['id'] = widget.id;
    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.diaryDetail, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = DiaryDetailEntity.fromJson(http.data);
        _tabController = TabController(
          length: _entity.fileUrlList.length,
          vsync: this,
        );
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _pageChange(int index) {
    _tabController.animateTo(index);
    setState(() {
      _currentImage = index + 1;
    });
  }

  void _attentionAction() async {
    bool isAttention = _entity.followStatus == 1;

    Map<String, String> params = Map();
    params['memberId'] = '${_entity.memberId}';

    ToastHud.loading(context);
    var http =
        await HttpManager.get(DsApi.followOrCancel, context, params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      if (_entity.followStatus == 0) {
        ToastHud.show(context, '取消关注');
      } else {
        if (isAttention) {
          ToastHud.show(context, '取消关注');
        } else {
          ToastHud.show(context, '关注成功');
        }
      }
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _shareAction() async {
    bool _isLogin = await UserManager.isLogin();
    if (!_isLogin) {
      return ToastHud.show(context, '未登录');
    }

    ToastHud.loading(context);
    var http = await HttpManager.get(DsApi.personInfo, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      MineEntity entity = MineEntity.fromJson(http.data);
      DetailDialog.showShareDialog(context, (String type) {
        if (int.parse(type) == 1) {
          var model = fluwx.WeChatShareWebPageModel(
              DsApi.share_url + '?inviteCode=${entity.inviteCode ?? ''}',
              title: '雀斑-${_entity.name}',
              description: '邀请你加入雀斑会员，带你一起变美一起赚钱！',
              thumbnail:
                  fluwx.WeChatImage.network(_entity.pic.split(',').first),
              scene: fluwx.WeChatScene.SESSION);
          fluwx.shareToWeChat(model).then((value) {
            ToastHud.show(context, '分享成功');
          });
        } else if (int.parse(type) == 2) {
          var model = fluwx.WeChatShareWebPageModel(
              DsApi.share_url + '?inviteCode=${entity.inviteCode ?? ''}',
              title: '雀斑-${_entity.name}',
              description: '邀请你加入雀斑会员，带你一起变美一起赚钱！',
              thumbnail:
                  fluwx.WeChatImage.network(_entity.pic.split(',').first),
              scene: fluwx.WeChatScene.TIMELINE);
          fluwx.shareToWeChat(model).then((value) {
            ToastHud.show(context, '分享成功');
          });
        } else if (int.parse(type) == 3) {
          Clipboard.setData(ClipboardData(
              text:
                  DsApi.share_url + '?inviteCode=${entity.inviteCode ?? ''}'));
          ToastHud.show(context, '复制成功');
        }
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _sendAction() async {
    Map<String, dynamic> params = Map();
    params['diaryDetailId'] = widget.id;
    params['content'] = _textEditingController.text;
    params['commentType'] = 0;
    ToastHud.loading(context);
    var http = await HttpManager.post(DsApi.diaryComment, params, context);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
      _currentPage = 1;
      _requestInfo();
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _commentAction() {
    _textEditingController.clear();
    Future.delayed(Duration(milliseconds: 200)).then((e) {
      ReplyDialog.showComment(
        context,
        _textEditingController,
        _focusNode,
        _sendAction,
      );
    });
  }

  void _praiseComment(DiaryCommentItemEntity item) async {
    Map<String, dynamic> params = Map();
    params['commentId'] = item.id;
    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.praiseDiaryComment,
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, http.message!);
      _currentPage = 1;
      _requestInfo();
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    AppBar _buildAppbar() {
      return AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Image.asset("assets/images/home/back.png",
                  width: 28, height: 28),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip);
        }),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: CommonWidgets.networkImage(_entity.icon),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Text(
                _entity.nickName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _attentionAction,
            child: Container(
              alignment: Alignment.center,
              width: 50,
              margin: const EdgeInsets.symmetric(vertical: 17),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  width: 1,
                  color: XCColors.bannerSelectedColor,
                ),
              ),
              child: Text(
                _entity.followStatus == 1 ? '已关注' : '关注',
                style: TextStyle(
                  fontSize: 12,
                  color: XCColors.tabNormalColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          IconButton(
              onPressed: _shareAction,
              icon: Image.asset("assets/images/home/home_detail_share.png",
                  width: 19, height: 19),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip)
        ],
      );
    }

    Widget _detailHeaderWidget() {
      return Stack(
        children: [
          Container(
            height: 375,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _entity.fileUrlList.length,
              itemBuilder: (context, index) {
                return CommonWidgets.networkImage(_entity.fileUrlList[index]);
              },
              onPageChanged: _pageChange,
            ),
          ),
          Positioned(
            right: 15,
            bottom: 8,
            child: Container(
              width: 30,
              height: 16,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              child: Text(
                '$_currentImage/${_entity.fileUrlList.length}',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      );
    }

    /// 商品item
    Widget _goodsItem() {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          NavigatorUtil.pushPage(
            context,
            DetailScreen(_entity.productId),
            needLogin: false,
          );
        },
        child: Container(
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: XCColors.categoryGoodsShadowColor,
                blurRadius: 10,
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: CommonWidgets.networkImage(_entity.pic),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _entity.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: XCColors.mainTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 7),
                    Row(
                      children: [
                        Text(
                          _entity.orgName,
                          style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 10,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${_entity.reserveNum}人已预约',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: XCColors.goodsGrayColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          '¥${_entity.price}',
                          style: TextStyle(
                            color: XCColors.themeColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '￥${_entity.price}',
                            style: TextStyle(
                              color: XCColors.goodsOtherGrayColor,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: XCColors.goodsOtherGrayColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            border: Border.all(
                              width: 1,
                              color: XCColors.themeColor,
                            ),
                          ),
                          child: Text(
                            '购买',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: XCColors.themeColor,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _contentView() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              _entity.content,
              style: TextStyle(
                fontSize: 14,
                color: XCColors.mainTextColor,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _entity.createTime,
              style: TextStyle(
                fontSize: 11,
                color: XCColors.goodsGrayColor,
              ),
            ),
          ],
        ),
      );
    }

    Widget _item(
      String title,
      String image,
      double imageWidth,
      double imageHeight,
    ) {
      return Column(
        children: [
          Image.asset(image, width: imageWidth, height: imageHeight),
          Text(
            title,
            style: TextStyle(
              color: XCColors.tabNormalColor,
              fontSize: 12,
            ),
          ),
        ],
      );
    }

    Widget _commentView() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 35,
              child: Text(
                '共$_total条评论',
                style: TextStyle(
                  fontSize: 12,
                  color: XCColors.tabNormalColor,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _commentAction,
              child: Container(
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                      ),
                      child: CommonWidgets.networkImage(_entity.icon),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 35,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: XCColors.homeDividerColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(17.5))),
                        child: Text(
                          '喜欢ta就留下评论吧',
                          style: TextStyle(
                            fontSize: 14,
                            color: XCColors.tabNormalColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: List.generate(
                _total,
                (index) {
                  DiaryCommentItemEntity item = _commentList[index];
                  return Container(
                    padding: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
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
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child:
                                        CommonWidgets.networkImage(item.icon),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    item.nickName,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: XCColors.goodsGrayColor,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.only(left: 33),
                                child: Text(
                                  item.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.mainTextColor,
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 33, bottom: 5),
                                child: Text(
                                  item.createTime,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: XCColors.goodsGrayColor,
                                  ),
                                ),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 33, bottom: 5),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width: 1,
                                      color: XCColors.homeDividerColor,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    item.diaryCommentVOS.length,
                                    (index) {
                                      DiaryCommentItemEntity replayItem =
                                          item.diaryCommentVOS[index];
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 20,
                                                height: 20,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                                child:
                                                    CommonWidgets.networkImage(
                                                        replayItem.icon),
                                              ),
                                              SizedBox(width: 3),
                                              Text(
                                                replayItem.nickName,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color:
                                                      XCColors.goodsGrayColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 23),
                                            child: Text(
                                              replayItem.content,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: XCColors.mainTextColor,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 23, bottom: 5),
                                            child: Text(
                                              replayItem.createTime,
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: XCColors.goodsGrayColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 13),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            _praiseComment(item);
                          },
                          child: _item(
                            item.praiseCount.toString(),
                            item.followStatus == 1
                                ? 'assets/images/home/home_detail_diary_like_selected.png'
                                : 'assets/images/home/home_detail_diary_like_normal.png',
                            20,
                            20,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _detailHeaderWidget(),
            Container(
              height: 20,
              child: XCPageSelector(
                controller: _tabController,
                color: XCColors.detailNormalColor,
                selectedColor: XCColors.detailSelectedColor,
                indicatorSize: 4,
              ),
            ),
            _goodsItem(),
            SizedBox(height: 15),
            _contentView(),
            SizedBox(height: 10),
            Container(height: 10, color: XCColors.homeDividerColor),
            _commentView(),
            Container(
              height: 40,
              alignment: Alignment.center,
              child: Text(
                '展开$_total条评论',
                style: TextStyle(
                  fontSize: 14,
                  color: XCColors.commentBlueColor,
                ),
              ),
            ),
            Container(height: 20, color: XCColors.homeDividerColor),
            OrderWidgets.payTipWidget(context),
            OrderWidgets.orderBodyWidget(context, _productList),
          ],
        ),
      ),
    );
  }

  // 保持页面状态
  @override
  bool get wantKeepAlive => true;
}
