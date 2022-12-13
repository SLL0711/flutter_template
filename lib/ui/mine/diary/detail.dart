import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_medical_beauty/api.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/empty.dart';
import 'package:flutter_medical_beauty/http.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/common/preview.dart';
import 'package:flutter_medical_beauty/ui/home/city/widgets.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/diary_detail.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/dialog.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/edit.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/diary/log.dart';
import 'package:flutter_medical_beauty/widgets.dart';

class DiaryBookDetailScreen extends StatefulWidget {
  final int bookId;
  final bool isOwner;

  DiaryBookDetailScreen(this.bookId, {this.isOwner = false});

  @override
  State<StatefulWidget> createState() => DiaryBookDetailScreenState();
}

class DiaryBookDetailScreenState extends State<DiaryBookDetailScreen>
    with AutomaticKeepAliveClientMixin {
  DiaryBooksEntity _entity = DiaryBooksEntity();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _requestInfo();
    });
  }

  void _requestInfo() async {
    Map<String, dynamic> params = Map();
    params['diaryBookId'] = widget.bookId;

    ToastHud.loading(context);
    var http = await HttpManager.get(
      DsApi.diaryBookDetail,
      context,
      params: params,
    );
    ToastHud.dismiss();
    if (http.code == 200) {
      setState(() {
        _entity = DiaryBooksEntity.fromJson(http.data);
      });
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  void _menuTapAction(int type) {
    if (type == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DiaryEditScreen(widget.bookId),
        ),
      ).then((value) {
        if (value == null) return;
        if (value == '1') {
          _requestInfo();
        }
      });
    } else {
      _deleteAction();
    }
  }

  void _deleteAction() async {
    Map<String, dynamic> params = Map();
    params['diaryId'] = widget.bookId;

    ToastHud.loading(context);
    var http = await HttpManager.delete(DsApi.deleteDiaryBook, context,
        params: params);
    ToastHud.dismiss();
    if (http.code == 200) {
      ToastHud.show(context, '删除成功');
      Navigator.pop(context, '1');
    } else {
      ToastHud.show(context, http.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    Widget _infoView() {
      return Container(
        height: 90,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(30),
                ),
              ),
              child: CommonWidgets.networkImage(_entity.icon),
            ),
            SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _entity.nickName,
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '手术时间：${_entity.operationTime}',
                    style: TextStyle(
                      fontSize: 10,
                      color: XCColors.tabNormalColor,
                    ),
                  ),
                  SizedBox(height: 7),
                  Text(
                    '共${_entity.vos.length}篇日记',
                    style: TextStyle(
                      fontSize: 10,
                      color: XCColors.tabNormalColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 6),
            Offstage(
              offstage: !widget.isOwner,
              child: Column(
                children: [
                  SizedBox(height: 15),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (TapDownDetails details) {
                      DiaryBookDialog.showTip(
                        context,
                        details.globalPosition.dx,
                        details.globalPosition.dy,
                        _menuTapAction,
                      );
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Image.asset(
                        'assets/images/mine/mine_diary_more.png',
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              ),
            ),
          ],
        ),
      );
    }

    Widget _goodsView() {
      return Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 15),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: XCColors.categoryGoodsShadowColor,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              child: CommonWidgets.networkImage(_entity.productPic),
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
                      fontSize: 12,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        _entity.doctorName,
                        style: TextStyle(
                          fontSize: 10,
                          color: XCColors.tabNormalColor,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          _entity.orgName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: XCColors.tabNormalColor,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '¥${_entity.price}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: XCColors.themeColor,
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

    Widget _photosView() {
      List<String> images = _entity.beforeImages.split(',');
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 42,
              child: Text(
                '术前照片（${images.length}）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
            Container(
              height: 88,
              child: ListView.builder(
                itemCount: images.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(
                        context,
                        PreviewImagesScreen(images, index),
                      );
                    },
                    child: Container(
                      height: 88,
                      width: 98,
                      margin: const EdgeInsets.only(right: 10),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(6),
                        ),
                      ),
                      child: CommonWidgets.networkImage(
                        images[index],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10)
          ],
        ),
      );
    }

    Widget _item(
        String title, String image, double imageWidth, double imageHeight) {
      return Row(
        children: [
          Image.asset(image, width: imageWidth, height: imageHeight),
          SizedBox(width: 3),
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

    Widget _diaryItemView(DiaryBooksItemEntity itemEntity) {
      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      double imageWidth = (screenWidth - 95) / 3.0;
      List<String> images = itemEntity.fileUrl.split(',');
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  SizedBox(height: 2),
                  Container(
                    height: 12,
                    width: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                      border: Border.all(
                        width: 2,
                        color: XCColors.themeColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: 1,
                      color: XCColors.categoryGoodsShadowColor,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          itemEntity.createTime.split(' ').first,
                          style: TextStyle(
                            fontSize: 14,
                            color: XCColors.tabNormalColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          itemEntity.projectName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: XCColors.mainTextColor,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '术后第${itemEntity.dayNum}天',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: XCColors.mainTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    images.isEmpty ? Container() : SizedBox(height: 10),
                    images.isEmpty
                        ? Container()
                        : Container(
                            height: imageWidth + 2,
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: images.length > 3 ? 3 : images.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                //横轴元素个数
                                crossAxisCount: 3,
                                //纵轴间距
                                mainAxisSpacing: 20,
                                //横轴间距
                                crossAxisSpacing: 20,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                bool isBlack = index == 2 && images.length > 3;
                                return isBlack
                                    ? Stack(
                                        children: [
                                          Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                            ),
                                            child: CommonWidgets.networkImage(
                                              images[index],
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 0,
                                            top: 0,
                                            child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                              child: Text(
                                                '+${images.length}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8))),
                                        child: CommonWidgets.networkImage(
                                          images[index],
                                        ),
                                      );
                              },
                            ),
                          ),
                    SizedBox(height: 8),
                    Text(
                      itemEntity.content,
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                    SizedBox(height: 14),
                    Row(children: [
                      _item(
                          itemEntity.readCount.toString(),
                          'assets/images/home/home_detail_diary_reading.png',
                          16,
                          9),
                      SizedBox(width: 15),
                      _item(
                          itemEntity.praiseCount.toString(),
                          'assets/images/home/home_detail_diary_like_normal.png',
                          17,
                          17),
                      SizedBox(width: 15),
                      _item(
                          itemEntity.replayCount.toString(),
                          'assets/images/home/home_detail_diary_comment.png',
                          12,
                          12)
                    ]),
                    SizedBox(height: 30)
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _diaryView() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 42,
              child: Text(
                '术后日记（${_entity.vos.length}）',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: XCColors.mainTextColor,
                ),
              ),
            ),
            Column(
              children: List.generate(
                _entity.vos.length,
                (index) {
                  DiaryBooksItemEntity itemEntity = _entity.vos[index];
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      NavigatorUtil.pushPage(
                        context,
                        DiaryDetailScreen(itemEntity.id),
                        needLogin: false,
                      );
                    },
                    child: _diaryItemView(itemEntity),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: XCColors.homeDividerColor,
      appBar: CityWidgets.cityAppBar(context, '颜值日记', () {
        Navigator.pop(context);
      }),
      body: _entity.nickName.isEmpty
          ? EmptyWidgets.dataEmptyView(context)
          : Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _infoView(),
                        SizedBox(height: 10),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {},
                          child: _goodsView(),
                        ),
                        SizedBox(height: 10),
                        _entity.beforeImages.isEmpty
                            ? Container()
                            : _photosView(),
                        _entity.vos.isEmpty ? Container() : _diaryView()
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 95,
                  child: Offstage(
                    offstage: !widget.isOwner,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DiaryCreateLogScreen(widget.bookId),
                          ),
                        ).then((value) {
                          if (value == null) return;
                          if (value == '1') {
                            _requestInfo();
                          }
                        });
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
                              '日记',
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
                ),
              ],
            ),
    );
  }

  // 页面保持
  @override
  bool get wantKeepAlive => true;
}
