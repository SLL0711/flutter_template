import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/navigator.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/hospital/entity.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

typedef VoidCallback onChange(int index);

abstract class HospitalWidgets {
  static hospitalBottomBool(BuildContext context, onChange) {
    Widget _item(String title, String image, bool isCall) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            int type = isCall ? 1 : 2;
            onChange(type);
          },
          child: Container(
            height: double.infinity,
            color: XCColors.themeColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  image,
                  width: 20,
                  height: 20,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _item(
              '电话咨询', 'assets/images/home/home_detail_hospital_call.png', true),
          // _item('在线咨询', 'assets/images/home/home_detail_hospital_online.png',
          //     false),
        ],
      ),
    );
  }

  static hospitalBanner(BuildContext context, PageController pageController,
      List<String> pics, int currentPage, onChange) {
    return Container(
      width: double.infinity,
      height: 227,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: pics.isEmpty
                ? Container()
                : PageView.builder(
                    controller: pageController,
                    itemCount: pics.length,
                    onPageChanged: onChange,
                    itemBuilder: (context, index) {
                      return CommonWidgets.networkImage(pics[index]);
                    },
                  ),
          ),
          Positioned(
            right: 15,
            bottom: 10,
            child: Text(
              '$currentPage/${pics.length}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  static hospitalInfo(
    BuildContext context,
    OrgEntity entity,
    bool isGrounding,
    VoidCallback callback,
  ) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 9, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(clipBehavior: Clip.none, children: [
            Container(
                width: 70,
                height: 70,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(35))),
                child: CommonWidgets.networkImage(entity.icon)),
            Positioned(
                top: 59,
                left: 14,
                child: Offstage(
                    offstage: entity.isAuth == 0,
                    child: Image.asset(
                        isGrounding
                            ? 'assets/images/mine/ic_auth.png'
                            : 'assets/images/mine/mine_footprint_doctor_certification.png',
                        height: 18,
                        width: 42)))
          ]),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Text(entity.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: XCColors.mainTextColor,
                        fontSize: 16)),
                SizedBox(height: 4),
                Row(children: [
                  Text(entity.score.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: XCColors.mainTextColor,
                          fontSize: 24)),
                  SizedBox(width: 6),
                  CommonWidgets.scoreWidget(
                      int.parse(entity.score.toString().split('.').first))
                ]),
                SizedBox(height: 3),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: callback,
                  child: Text(
                    '地址：${entity.address}',
                    style: TextStyle(
                      color: XCColors.tabNormalColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static hospitalNumber(
    BuildContext context,
    OrgEntity entity,
    bool isGrounding,
    onChange,
  ) {
    Widget _item(String value, String title, int type) {
      return Expanded(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                onChange(type);
              },
              child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(value,
                            style: TextStyle(
                                color: XCColors.mainTextColor, fontSize: 18)),
                        SizedBox(height: 2),
                        Text(title,
                            style: TextStyle(
                                color: XCColors.tabNormalColor, fontSize: 14))
                      ]))));
    }

    return Container(
        width: double.infinity,
        height: 62,
        color: Colors.white,
        margin: const EdgeInsets.only(top: 1),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _item(entity.subscribeNum.toString(), '预约', 1),
          _item(entity.doctorNum.toString(), isGrounding ? '技师' : '咨询师', 2),
          _item(entity.caseNum.toString(), '真实案例', 3)
        ]));
  }

  static hospitalGoods(BuildContext context, OrgEntity entity) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = (screenWidth - 50) / 3.0;

    Widget _item(ProductItemEntity itemEntity) {
      return Expanded(
        child: itemEntity.name.isEmpty
            ? Container()
            : GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NavigatorUtil.pushPage(context, DetailScreen(itemEntity.id),
                      needLogin: false);
                },
                child: Container(
                  width: imageWidth,
                  child: Column(
                    children: [
                      Container(
                          width: imageWidth,
                          height: imageWidth,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: CommonWidgets.networkImage(itemEntity.pic)),
                      SizedBox(height: 5),
                      Text(itemEntity.name,
                          style: TextStyle(
                              fontSize: 12, color: XCColors.mainTextColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '¥${itemEntity.price}',
                            style: TextStyle(
                              fontSize: 14,
                              color: XCColors.themeColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                              child: Text('已售${itemEntity.sale}',
                                  textAlign: TextAlign.end,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: XCColors.goodsGrayColor)))
                        ],
                      ),
                      SizedBox(height: 10)
                    ],
                  ),
                ),
              ),
      );
    }

    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(5, (i) {
              if (i == 1 || i == 3) {
                return SizedBox(width: 10);
              }
              int index = i == 2
                  ? 1
                  : (i == 4)
                      ? 2
                      : i;
              ProductItemEntity itemEntity = ProductItemEntity();
              if (index < entity.productList.list.length) {
                itemEntity = entity.productList.list[index];
              }
              return _item(itemEntity);
            })));
  }

  static hospitalDescribe(
    BuildContext context,
    OrgEntity entity,
    bool isGrounding,
  ) {
    return Container(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: [
          SizedBox(height: 14),
          Text(isGrounding ? '门店简介' : '商家简介',
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 16)),
          SizedBox(height: 14),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: entity.description.isEmpty
                  ? Container()
                  : Html(data: entity.description)),
          SizedBox(height: 20)
        ]));
  }
}
