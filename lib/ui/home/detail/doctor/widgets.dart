import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/toast.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/diary_detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/tabbar_view/comment_detail.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/ui/mine/footprint/widgets.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

typedef VoidCallback onTap(int type);

abstract class DoctorWidgets {
  static doctorDetailInfo(
      BuildContext context, DoctorItemEntity entity, bool isGrounding, onTap) {
    return Container(
        color: Colors.white,
        child: Column(children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(children: [
                Stack(clipBehavior: Clip.none, children: [
                  Container(
                      width: 60,
                      height: 60,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: CommonWidgets.networkImage(entity.avatar)),
                  Positioned(
                      top: 49,
                      left: 9,
                      child: Offstage(
                          offstage: entity.isAuth != 1,
                          child: Image.asset(
                              isGrounding
                                  ? 'assets/images/mine/ic_auth.png'
                                  : 'assets/images/mine/mine_footprint_doctor_certification.png',
                              height: 18,
                              width: 42)))
                ]),
                SizedBox(width: 10),
                Expanded(
                    child: Column(children: [
                  Row(children: [
                    Text(entity.name,
                        style: TextStyle(
                            fontSize: 16, color: XCColors.mainTextColor)),
                    SizedBox(width: 5),
                    Text(entity.duties,
                        style: TextStyle(
                            fontSize: 10, color: XCColors.tabNormalColor)),
                    SizedBox(width: 5),
                    Container(
                        width: 1, height: 10, color: XCColors.homeDividerColor),
                    SizedBox(width: 5),
                    Text('从业${entity.year}年',
                        style: TextStyle(
                            fontSize: 10, color: XCColors.tabNormalColor))
                  ]),
                  SizedBox(height: 6),
                  Row(children: [
                    CommonWidgets.scoreWidget(
                        int.parse(entity.score.toString().split('.').first)),
                    SizedBox(width: 10),
                    Text('${entity.commentNum}条评论',
                        style: TextStyle(
                            fontSize: 10, color: XCColors.goodsGrayColor))
                  ])
                ]))
              ])),
          SizedBox(height: 7),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              onTap(0);
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(entity.subscribeNum.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: XCColors.mainTextColor)),
                                  SizedBox(height: 3),
                                  Text('预约',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: XCColors.tabNormalColor))
                                ]))),
                    Container(
                        width: 1, height: 40, color: XCColors.homeDividerColor),
                    Expanded(
                        child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              onTap(1);
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(entity.caseNum.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: XCColors.mainTextColor)),
                                  SizedBox(height: 3),
                                  Text('案例',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: XCColors.tabNormalColor))
                                ])))
                  ])),
          Container(
              width: double.infinity,
              height: 1,
              color: XCColors.homeDividerColor),
          Container(
              padding: const EdgeInsets.all(15),
              child: Row(children: [
                Text('擅长项目',
                    style:
                        TextStyle(fontSize: 14, color: XCColors.mainTextColor)),
                SizedBox(width: 10),
                Expanded(
                    child: entity.doctorProjectListVOS.isEmpty
                        ? Container()
                        : Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: entity.doctorProjectListVOS.map((e) {
                              return Container(
                                  height: 20,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, top: 3),
                                  decoration: BoxDecoration(
                                      color: XCColors.bannerHintColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Text(e.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: XCColors.tabNormalColor)));
                            }).toList()))
              ]))
        ]));
  }

  static doctorInfo(BuildContext context, bool isGrounding, onTap) {
    Widget _item(String image, String title, double imageWidth,
        double imageHeight, int type) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            onTap(type);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(image, width: imageWidth, height: imageHeight),
              SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  color: XCColors.mainTextColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
        height: 90,
        color: Colors.white,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _item(
            'assets/images/home/home_doctor_info.png',
            isGrounding ? '技师资料' : '咨询师资料',
            27,
            31,
            0,
          ),
          SizedBox(width: 20),
          _item(
            'assets/images/home/home_doctor_certificate.png',
            isGrounding ? '技师证件' : '咨询师证件',
            36,
            32,
            1,
          ),
          SizedBox(width: 20),
          _item(
            'assets/images/home/home_doctor_honor.png',
            '荣誉展示',
            35,
            32,
            2,
          )
        ]));
  }

  static doctorAddressInfo(BuildContext context, DoctorItemEntity entity) {
    return Container(
        padding: const EdgeInsets.all(15),
        color: Colors.white,
        child: Row(children: [
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(entity.organizationInfo.name,
                    style: TextStyle(
                        fontSize: 16,
                        color: XCColors.mainTextColor,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 3),
                Text(entity.organizationInfo.address,
                    style:
                        TextStyle(fontSize: 12, color: XCColors.tabNormalColor))
              ])),
          SizedBox(width: 30),
          Container(width: 1, height: 30, color: XCColors.homeDividerColor),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () async {
                String url =
                    '${Platform.isAndroid ? 'android' : 'ios'}amap://navi?sourceApplication=amap&lat=${entity.organizationInfo.latitude}&lon=${entity.organizationInfo.longitude}&dev=0&style=2&poiname=${entity.organizationInfo.name}';
                print('=======url======= $url');
                if (Platform.isIOS) {
                  url = Uri.encodeFull(url);
                }
                try {
                  if (await canLaunch(url) != null) {
                    await launch(url);
                  }
                } on Exception catch (e) {
                  ToastHud.show(context, '无法调起高德地图');
                }
              },
              child: Container(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 11, bottom: 11),
                  height: 40,
                  width: 45,
                  child: Image.asset(
                      'assets/images/home/home_doctor_location.png',
                      width: 14,
                      height: 18)))
        ]));
  }

  static doctorGoodsInfo(BuildContext context,
      List<ProductItemEntity> goodsList, int total, final VoidCallback onTap) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageHeight = (screenWidth - 20) / 3.0;

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Column(children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                  height: 50,
                  child: Row(children: [
                    Text('服务项目',
                        style: TextStyle(
                            fontSize: 16, color: XCColors.mainTextColor)),
                    Expanded(
                        child: Text('全部（$total）',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 12, color: XCColors.tabNormalColor))),
                    SizedBox(width: 5),
                    CommonWidgets.grayRightArrow()
                  ]))),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (i) {
                if (i == 1 || i == 3) {
                  return Container(width: 10, height: 50);
                }
                int index = i == 2
                    ? 1
                    : (i == 4)
                        ? 2
                        : i;
                ProductItemEntity entity = ProductItemEntity();
                if (index < goodsList.length) {
                  entity = goodsList[index];
                }
                return Expanded(
                    child: entity.name.isEmpty
                        ? Container()
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              NavigatorUtil.pushPage(
                                  context, DetailScreen(entity.id),
                                  needLogin: false);
                            },
                            child: Container(
                                child: Column(children: [
                              Container(
                                  height: imageHeight,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child:
                                      CommonWidgets.networkImage(entity.pic)),
                              SizedBox(height: 5),
                              Text(entity.name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: XCColors.tabNormalColor)),
                              SizedBox(height: 5),
                              Row(children: [
                                Text(
                                  '¥${entity.price}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: XCColors.themeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                    child: Text('已售${entity.sale}',
                                        maxLines: 1,
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: XCColors.goodsGrayColor))),
                              ]),
                              SizedBox(height: 15)
                            ]))));
              }))
        ]));
  }

  static doctorDiaryInfo(BuildContext context, List<DiaryItemEntity> goodsList,
      int total, final VoidCallback onTap) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                children: [
                  Text('精品日记',
                      style: TextStyle(
                          fontSize: 16, color: XCColors.mainTextColor)),
                  Expanded(
                    child: Text(
                      '全部（$total）',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          fontSize: 12, color: XCColors.tabNormalColor),
                    ),
                  ),
                  SizedBox(width: 5),
                  CommonWidgets.grayRightArrow()
                ],
              ),
            ),
          ),
          Column(
            children: List.generate(
              goodsList.length > 2 ? 2 : goodsList.length,
              (index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    NavigatorUtil.pushPage(
                        context, DiaryDetailScreen(goodsList[index].id),
                        needLogin: false);
                  },
                  child: FootprintWidgets.diaryItem(context, goodsList[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static doctorEvaluationInfo(
      BuildContext context,
      List<CommentItemEntity> commentList,
      int total,
      final VoidCallback onTap) {
    Widget _item(
        String title, String image, double imageWidth, double imageHeight) {
      return Row(children: [
        Image.asset(image, width: imageWidth, height: imageHeight),
        SizedBox(width: 3),
        Text(title,
            style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
      ]);
    }

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        color: Colors.white,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              height: 50,
              child: Row(
                children: [
                  Text(
                    '评价',
                    style: TextStyle(
                      fontSize: 16,
                      color: XCColors.mainTextColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '全部（$total）',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 12,
                        color: XCColors.tabNormalColor,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  CommonWidgets.grayRightArrow()
                ],
              ),
            ),
          ),
          // Container(
          //     color: Colors.white,
          //     padding: const EdgeInsets.only(top: 15, bottom: 15),
          //     child: _childrenList.isEmpty
          //         ? Container()
          //         : Wrap(
          //             spacing: 15,
          //             runSpacing: 15,
          //             alignment: WrapAlignment.start,
          //             children: _childrenList.map((e) {
          //               return GestureDetector(
          //                   behavior: HitTestBehavior.opaque,
          //                   onTap: () {},
          //                   child: Container(
          //                       height: 25,
          //                       padding: const EdgeInsets.only(
          //                           left: 9, right: 9, top: 4),
          //                       decoration: BoxDecoration(
          //                           color: e.isSelected
          //                               ? XCColors.bannerSelectedColor
          //                               : XCColors.homeDividerColor,
          //                           borderRadius: BorderRadius.all(
          //                               Radius.circular(12.5))),
          //                       child: Text(e.city,
          //                           maxLines: 1,
          //                           overflow: TextOverflow.ellipsis,
          //                           style: TextStyle(
          //                               fontSize: 12,
          //                               color: e.isSelected
          //                                   ? Colors.white
          //                                   : XCColors.mainTextColor))));
          //             }).toList())),
          Column(
              children: List.generate(commentList.length, (index) {
            CommentItemEntity itemEntity = commentList[index];
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                // NavigatorUtil.pushPage(context, CommentDetailView(itemEntity.id));
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: XCColors.homeDividerColor))),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 40,
                            height: 40,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: CommonWidgets.networkImage(
                                itemEntity.memberIcon)),
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
                              Row(children: [
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
                                    17)
                              ])
                            ]))
                      ])),
            );
          }))
        ]));
  }
}
