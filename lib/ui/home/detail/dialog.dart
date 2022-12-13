import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../../colors.dart';
import 'entity.dart';

typedef VoidCallback confirm(String result);

class DetailDialog {
  /// ===========  预约金弹窗  =============
  static void showGoldTip(BuildContext context) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 0,
            right: 0,
            child: Center(
                child: Column(children: [
              Container(
                  width: 230,
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(children: [
                    SizedBox(height: 20),
                    Text('什么是预约金',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 16,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.normal)),
                    SizedBox(height: 9),
                    Text('预约金是您在雀斑购买项目时预先支付的定金，剩余的项目尾款可以通过雀斑分期线上支付或者到店后线下支付。',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.normal,
                            height: 1.6)),
                    SizedBox(height: 10),
                    Text('即:预约金+项目尾款＝颜值价\n注:预约金在您消费之前可退，过期未消费也可退。',
                        style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                            color: XCColors.mainTextColor,
                            fontWeight: FontWeight.normal,
                            height: 1.6)),
                    SizedBox(height: 20)
                  ])),
              SizedBox(height: 40),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      width: 30,
                      height: 30,
                      child: Image.asset(
                          'assets/images/home/home_detail_tip_close.png',
                          fit: BoxFit.cover)))
            ])))
      ]);
    }

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }

  /// ===========  分享  =============
  static void showShareDialog(BuildContext context, confirm) {
    Widget _item(String title, String image, String type) {
      return Expanded(
          child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                confirm(type);
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(image, width: 50, height: 50),
                    SizedBox(height: 5),
                    Text(title,
                        style: TextStyle(
                            fontSize: 12,
                            color: XCColors.tabNormalColor,
                            decoration: TextDecoration.none))
                  ])));
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: 208,
                color: Colors.white,
                padding: const EdgeInsets.only(top: 7, left: 15, right: 15),
                child: Column(children: [
                  Container(
                      height: 85,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _item(
                                '微信好友',
                                'assets/images/home/home_detail_share_wechat.png',
                                '1'),
                            _item(
                                '朋友圈',
                                'assets/images/home/home_detail_share_friends.png',
                                '2'),
                            _item(
                                '复制链接',
                                'assets/images/home/home_detail_share_link.png',
                                '3'),
                            Expanded(child: Container())
                          ]))
                ])))
      ]);
    }

    showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (cxt, state) {
            return _buildBody(state);
          },
        );
      },
    );
  }

  /// ===========  套餐  =============
  static void showComboDialog(
      BuildContext context,
      List<DetailComboEntity> comboList,
      DetailComboEntity selectedCombo,
      confirm) {
    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              padding: const EdgeInsets.only(
                  top: 30, left: 15, right: 15, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: CommonWidgets.networkImage(selectedCombo.pic)),
                    SizedBox(width: 15),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          SizedBox(height: 7),
                          Row(children: [
                            Text(
                              '¥',
                              style: TextStyle(
                                fontSize: 22,
                                color: XCColors.themeColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(selectedCombo.totalPrice.toString(),
                                style: TextStyle(
                                    fontSize: 18,
                                    color: XCColors.bannerSelectedColor,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.none))
                          ]),
                          SizedBox(height: 3),
                          Text('今日剩余： ${selectedCombo.stock}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: XCColors.tabNormalColor,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none)),
                          SizedBox(height: 10),
                          Text('已选：${selectedCombo.spDataList.first.value}',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: XCColors.tabNormalColor,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.none))
                        ])),
                    GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          comboList.forEach((element) {
                            element.isSelected = element.isRealSelected;
                          });
                          Navigator.pop(context);
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(7.5),
                            child: Image.asset(
                                'assets/images/home/home_detail_combo_close.png')))
                  ]),
                  SizedBox(height: 20),
                  Text('套餐组合：',
                      style: TextStyle(
                          fontSize: 14,
                          color: XCColors.mainTextColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none)),
                  SizedBox(height: 16),
                  comboList.isEmpty
                      ? Container()
                      : Wrap(
                          spacing: 15,
                          runSpacing: 10,
                          alignment: WrapAlignment.start,
                          children: comboList.map(
                            (e) {
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setState(
                                    () {
                                      comboList.forEach((element) {
                                        element.isSelected = false;
                                      });
                                      e.isSelected = true;
                                      selectedCombo = e;
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: e.isSelected
                                          ? XCColors.themeColor
                                          : Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(6)),
                                      border: Border.all(
                                          width: 1,
                                          color: e.isSelected
                                              ? Colors.transparent
                                              : XCColors
                                                  .mineHeaderDividerColor)),
                                  child: Text(
                                    e.spDataList.first.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        decoration: TextDecoration.none,
                                        color: e.isSelected
                                            ? Colors.white
                                            : XCColors.tabNormalColor),
                                  ),
                                ),
                              );
                            },
                          ).toList()),
                  SizedBox(height: 30),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      comboList.forEach((element) {
                        element.isRealSelected = element.isSelected;
                      });

                      confirm(selectedCombo.spDataList.first.value);
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      decoration: BoxDecoration(
                          color: XCColors.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Text(
                        '确定',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }

    showDialog(
        barrierDismissible: false,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }

  /// ===========  套餐  =============
  static void showCouponsDialog(BuildContext context) {
    Widget _couponItem(int index) {
      return Container(
          height: 120,
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border:
                  Border.all(width: 1, color: XCColors.bannerSelectedColor)),
          child: Row(children: [
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              RichText(
                  text: TextSpan(
                      text: '¥',
                      style: TextStyle(
                          color: XCColors.bannerSelectedColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none),
                      children: [
                    TextSpan(
                        text: '300',
                        style: TextStyle(
                            color: XCColors.bannerSelectedColor,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none))
                  ])),
              SizedBox(height: 3),
              Text('满699减300',
                  style: TextStyle(
                      color: XCColors.goodsGrayColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none))
            ]),
            SizedBox(width: 20),
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text('美美大减价红包',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.mainTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none)),
                  SizedBox(height: 10),
                  Text('颜范美容限用',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.goodsGrayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none)),
                  SizedBox(height: 5),
                  Text('2019-07-07到期',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: XCColors.goodsGrayColor,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none))
                ])),
            SizedBox(width: 20),
            index == 0
                ? Image.asset(
                    'assets/images/home/home_detail_coupon_received.png',
                    width: 62,
                    height: 55)
                : Container(
                    width: 60,
                    height: 22,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: XCColors.bannerSelectedColor,
                      borderRadius: BorderRadius.all(Radius.circular(11)),
                    ),
                    child: Text('立即领取',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none)))
          ]));
    }

    /// 弹窗主要布局
    Widget _buildBody(StateSetter setState) {
      return Stack(alignment: Alignment.center, children: [
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                height: 415,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                padding: const EdgeInsets.only(
                    top: 12, left: 15, right: 15, bottom: 30),
                child: Column(children: [
                  Row(children: [
                    SizedBox(width: 30),
                    Expanded(
                        child: Text('可领取颜值券',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                color: XCColors.mainTextColor,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none))),
                    Container(width: 30, height: 30, color: Colors.red)
                  ]),
                  SizedBox(height: 10),
                  Expanded(
                      child: MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return _couponItem(index);
                              })))
                ])))
      ]);
    }

    showDialog(
        useSafeArea: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (cxt, state) {
            return _buildBody(state);
          });
        });
  }
}
