import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/detail/doctor/entity.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/entity.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../../colors.dart';

abstract class FootprintWidgets {
  /// ========= FootprintAppbar =========
  static footprintAppbar(
      BuildContext context, String title, final VoidCallback backTap) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            onPressed: backTap,
            icon: Image.asset(
              "assets/images/home/back.png",
              width: 28,
              height: 28,
            ),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        },
      ),
      /*actions: [
        Container(
            height: kToolbarHeight,
            width: 40,
            padding: const EdgeInsets.only(left: 8, right: 15),
            child: Image.asset('assets/images/mine/mine_footprint_delete.png',
                width: 17, height: 18))
      ],*/
      title: Text(
        title,
        style: TextStyle(
            fontSize: 18,
            color: XCColors.mainTextColor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  /// ========= 组头 =========
  static listHeaderItem(BuildContext context, bool isFirst,
      {bool isDoctor = false}) {
    return Container(
      height: (isFirst ? (isDoctor ? 27 : 30) : 40),
      alignment: isFirst ? Alignment.topLeft : Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 15),
      child: Text('7月3日',
          style: TextStyle(fontSize: 14, color: XCColors.goodsGrayColor)),
    );
  }

  /// ========= 商品 =========
  static goodsItem(BuildContext context, ProductItemEntity itemEntity) {
    Widget _bodyWidget() {
      return Row(children: [
        Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: CommonWidgets.networkImage(itemEntity.pic)),
        SizedBox(width: 10),
        Expanded(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Text(itemEntity.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      TextStyle(color: XCColors.mainTextColor, fontSize: 14)),
              SizedBox(height: 16),
              Row(children: [
                Expanded(
                    child: Row(children: [
                  RichText(
                      text: TextSpan(
                          text: '¥',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: XCColors.bannerSelectedColor,
                              fontSize: 18),
                          children: [
                        TextSpan(
                            text: itemEntity.price.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: XCColors.bannerSelectedColor,
                                fontSize: 22))
                      ])),
                  SizedBox(width: 5),
                  Expanded(
                      child: Text('',
                          style: TextStyle(
                              color: XCColors.goodsOtherGrayColor,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: XCColors.goodsOtherGrayColor,
                              fontSize: 12)))
                ])),
                Text('已售 ${itemEntity.sale}',
                    style: TextStyle(
                        color: XCColors.goodsOtherGrayColor, fontSize: 11))
              ]),
              SizedBox(height: 7)
            ]))
      ]);
    }

    return Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(left: 15, right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
          ],
        ),
        child: _bodyWidget());
  }

  /// ========= 日记 =========
  static diaryItem(BuildContext context, DiaryItemEntity entity) {
    Widget _item(
        String title, String image, double imageWidth, double imageHeight) {
      return Row(children: [
        Image.asset(image, width: imageWidth, height: imageHeight),
        SizedBox(width: 3),
        Text(title,
            style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
      ]);
    }

    Widget _bodyWidget() {
      /// 屏幕宽度
      double screenWidth = MediaQuery.of(context).size.width;
      double imageWidth = (screenWidth - 39) * 0.5;
      List<String> images = <String>[];
      int count = 0;
      if (entity.beforeImages.isNotEmpty) {
        images = entity.beforeImages.split(',');
        count = images.length == 1 ? 1 : 3;
      }

      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 15),
        images.isEmpty
            ? Container()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(count, (index) {
                  if (index == 1) return SizedBox(width: 9);
                  int i = index > 1 ? 1 : 0;
                  return Expanded(
                      child: Container(
                          height: imageWidth,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: CommonWidgets.networkImage(images[i])));
                })),
        SizedBox(height: 10),
        Text(entity.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 14)),
        SizedBox(height: 5),
        Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: XCColors.addressDividerColor),
            child: Row(children: [
              Expanded(
                  child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                          text: '【${entity.projectName}】',
                          style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 11,
                          ),
                          children: [
                            WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                        color: XCColors.tabNormalColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2))))),
                            TextSpan(
                                text: ' ${entity.orgName}',
                                style: TextStyle(
                                    color: XCColors.tabNormalColor,
                                    fontSize: 11))
                          ]))),
              SizedBox(width: 10),
              Text('¥${entity.price}',
                  style: TextStyle(
                      color: XCColors.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,),),
            ])),
        Container(
            padding: const EdgeInsets.only(left: 4, top: 10, bottom: 10),
            child: Row(children: [
              Container(
                  width: 40,
                  height: 40,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: CommonWidgets.networkImage(entity.icon)),
              SizedBox(width: 5),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(entity.memberNickName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: XCColors.mainTextColor)),
                    SizedBox(height: 2),
                    Text(entity.createTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11, color: XCColors.goodsOtherGrayColor))
                  ])),
              SizedBox(width: 5),
              Row(children: [
                _item(entity.readCount.toString(),
                    'assets/images/home/home_detail_diary_reading.png', 16, 9),
                SizedBox(width: 15),
                _item(
                    entity.praiseCount.toString(),
                    'assets/images/home/home_detail_diary_like_normal.png',
                    17,
                    17),
                SizedBox(width: 15),
                _item(entity.replayCount.toString(),
                    'assets/images/home/home_detail_diary_comment.png', 12, 12)
              ])
            ]))
      ]);
    }

    return Column(children: [
      Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: Colors.white,
          child: _bodyWidget()),
      Container(height: 1, color: XCColors.homeDividerColor)
    ]);
  }

  /// ========= 商家 =========
  static hospitalItem(
    BuildContext context,
    OrgEntity entity,
    bool isGrounding,
  ) {
    Widget _bodyWidget() {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(clipBehavior: Clip.none, children: [
          Container(
            width: 60,
            height: 60,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: CommonWidgets.networkImage(entity.icon),
          ),
          Offstage(
              offstage: entity.isAuth == 0,
              child: Positioned(
                  top: 49,
                  left: 9,
                  child: Image.asset(
                      isGrounding
                          ? 'assets/images/mine/ic_auth.png'
                          : 'assets/images/mine/mine_footprint_doctor_certification.png',
                      height: 18,
                      width: 42)))
        ]),
        SizedBox(width: 15),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(entity.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: XCColors.mainTextColor,
                  fontSize: 14)),
          SizedBox(height: 4),
          Row(children: [
            CommonWidgets.scoreWidget(
                int.parse(entity.score.toString().split('.').first)),
            Text('${entity.subscribeNum}预约',
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 11)),
            SizedBox(width: 5),
            Container(
                height: 10, width: 1, color: XCColors.mineHeaderDividerColor),
            SizedBox(width: 5),
            Expanded(
                child: Text('${entity.caseNum}案例',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: XCColors.tabNormalColor, fontSize: 11)))
          ]),
          SizedBox(height: 3),
          Text(entity.address,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 11))
        ]))
      ]);
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
        padding: const EdgeInsets.only(right: 12, top: 10, bottom: 15),
        color: Colors.white,
        child: _bodyWidget());
  }

  /// ========= 咨询师 =========
  static doctorItem(
    BuildContext context,
    DoctorItemEntity entity,
    bool isGrounding,
  ) {
    Widget _bodyWidget() {
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 60,
            height: 60,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: entity.avatar.isEmpty
                ? Image.asset('assets/images/mine/mine_avatar.png')
                : CommonWidgets.networkImage(entity.avatar)),
        SizedBox(width: 15),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(height: 4),
          Row(
            children: [
              Text(entity.name,
                  style:
                      TextStyle(color: XCColors.mainTextColor, fontSize: 16)),
              SizedBox(width: 5),
              Offstage(
                offstage: entity.isAuth != 1,
                child: Image.asset(
                  isGrounding
                      ? 'assets/images/mine/ic_auth.png'
                      : 'assets/images/mine/mine_footprint_doctor_certification.png',
                  height: 18,
                  width: 42,
                ),
              ),
            ],
          ),
          SizedBox(height: 3),
          Row(children: [
            Text(entity.orgName,
                style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 11)),
            SizedBox(width: 5),
            Container(height: 12, width: 1, color: XCColors.goodsGrayColor),
            SizedBox(width: 5),
            Expanded(
                child: Text(entity.duties,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: XCColors.goodsGrayColor, fontSize: 11)))
          ]),
          SizedBox(height: 4),
          Row(children: [
            CommonWidgets.scoreWidget(entity.commentNum),
            SizedBox(width: 5),
            Text('${entity.subscribeNum}预约',
                style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 11)),
            SizedBox(width: 5),
            Container(
                height: 10, width: 1, color: XCColors.mineHeaderDividerColor),
            SizedBox(width: 5),
            Expanded(
                child: Text('${entity.caseNum}案例',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: XCColors.goodsGrayColor, fontSize: 11)))
          ]),
          SizedBox(height: 10),
          entity.doctorProjectListVOS.isEmpty
              ? Container()
              : Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  children: List.generate(entity.doctorProjectListVOS.length,
                      (index) {
                    DoctorProjectEntity projectEntity =
                        entity.doctorProjectListVOS[index];
                    return Container(
                        width: 60,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: XCColors.bannerHintColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Text(projectEntity.name,
                            style: TextStyle(
                                fontSize: 11, color: XCColors.tabNormalColor)));
                  }))
        ]))
      ]);
    }

    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.only(left: 16, right: 14, top: 10, bottom: 21),
        color: Colors.white,
        child: _bodyWidget());
  }
}
