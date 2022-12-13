import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/ui/home/detail/entity.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';

import '../../../colors.dart';
import '../../../navigator.dart';
import '../widgets.dart';
import 'order/order.dart';

typedef VoidCallback tapAction(int index);

abstract class DetailWidgets {
  /// ========= DetailAppbar =========
  static detailAppBar(
      BuildContext context,
      bool isCollect,
      final VoidCallback backTap,
      final VoidCallback collectTap,
      final VoidCallback shareTap) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              onPressed: backTap,
              icon: Image.asset("assets/images/home/back.png",
                  width: 28, height: 28),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip);
        }),
        actions: [
          IconButton(
              onPressed: collectTap,
              icon: Image.asset(
                  isCollect
                      ? 'assets/images/home/home_detail_collection_selected.png'
                      : "assets/images/home/home_detail_collection.png",
                  width: 23,
                  height: 23),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip),
          IconButton(
              onPressed: shareTap,
              icon: Image.asset("assets/images/home/home_detail_share.png",
                  width: 19, height: 19),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip)
        ]);
  }

  static detailChildAppBar(BuildContext context, String title,
      final VoidCallback backTap, final VoidCallback shareTap) {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: backTap,
            icon: Image.asset("assets/images/home/back.png",
                width: 28, height: 28),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
        actions: [
          // IconButton(
          //     onPressed: backTap,
          //     icon: Image.asset("assets/images/home/home_detail_share.png",
          //         width: 19, height: 19),
          //     tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip)
        ],
        title: Text(title,
            style: TextStyle(
                fontSize: 18,
                color: XCColors.mainTextColor,
                fontWeight: FontWeight.bold)));
  }

  /// 详情页的头部
  VoidCallback pageChange(int index);

  VoidCallback itemTap(int index);

  static detailHeaderWidget(
      BuildContext context,
      PageController pageController,
      TabController tabController,
      ProductDetailEntity detailEntity,
      pageChange,
      itemTap,
      String comboResult,
      bool isGrounding,
      bool isBean,
      bool isBeanGoods) {
    Widget _infoItem(String title, String subTitle, int index) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            itemTap(index);
          },
          child: Container(
            height: 80,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: XCColors.detailInfoTextColor,
                    fontSize: 14,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: XCColors.goodsGrayColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget _infoOtherItem(String title, String subTitle, int index) {
      return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            itemTap(index);
          },
          child: Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
            ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        color: XCColors.detailInfoTextColor, fontSize: 14)),
                Text(subTitle,
                    style:
                        TextStyle(color: XCColors.goodsGrayColor, fontSize: 12))
              ],
            ),
          ));
    }

    Widget _infoCountItem() {
      return Expanded(
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
          ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${detailEntity.product.sale}人已预约',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 12),
              ),
              SizedBox(height: 2),
              Text(
                '库存：${detailEntity.product.stock}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 12),
              )
            ],
          ),
        ),
      );
    }

    Widget _iconItem(String image, String title, int index) {
      return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            itemTap(index);
          },
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(image, width: 33, height: 31),
                SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(
                    color: XCColors.mainTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Column(
        children: [
          detailEntity.product.albumPicsList.isEmpty
              ? Container()
              : Container(
                  height: 345,
                  child: PageView.builder(
                      controller: pageController,
                      itemCount: detailEntity.product.albumPicsList.length,
                      itemBuilder: (context, index) {
                        return CommonWidgets.networkImage(
                            detailEntity.product.albumPicsList[index]);
                      },
                      onPageChanged: pageChange)),
          detailEntity.product.albumPicsList.isEmpty
              ? Container()
              : Container(
                  height: 20,
                  child: XCPageSelector(
                      controller: tabController,
                      color: XCColors.detailNormalColor,
                      selectedColor: XCColors.detailSelectedColor,
                      indicatorSize: 6)),
          // SizedBox(height: 7),
          // Row(children: [
          //   RichText(
          //       text: TextSpan(
          //           text: '8888',
          //           style: TextStyle(
          //               color: XCColors.tabNormalColor,
          //               fontSize: 12,
          //               fontWeight: FontWeight.bold),
          //           children: [
          //         TextSpan(
          //             text: '人已预约',
          //             style: TextStyle(
          //                 color: XCColors.tabNormalColor, fontSize: 12))
          //       ])),
          //   SizedBox(width: 35),
          //   RichText(
          //       text: TextSpan(
          //           text: '库存：',
          //           style:
          //               TextStyle(color: XCColors.tabNormalColor, fontSize: 12),
          //           children: [
          //         TextSpan(
          //             text: '9999',
          //             style: TextStyle(
          //                 color: XCColors.tabNormalColor,
          //                 fontSize: 12,
          //                 fontWeight: FontWeight.bold))
          //       ])),
          //   Expanded(
          //       child: RichText(
          //           textAlign: TextAlign.end,
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //           text: TextSpan(
          //               text: '每日限量剩余：',
          //               style: TextStyle(
          //                   color: XCColors.tabNormalColor,
          //                   fontSize: 12,
          //                   fontWeight: FontWeight.bold),
          //               children: [
          //                 TextSpan(
          //                     text: '9999',
          //                     style: TextStyle(
          //                         color: XCColors.tabNormalColor, fontSize: 12))
          //               ])))
          // ]),
          SizedBox(height: 10),
          Text(detailEntity.product.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Text(detailEntity.name,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12)),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              detailEntity.product.isEnableFee == 0
                  ? RichText(
                      text: TextSpan(
                        text: '¥',
                        style: TextStyle(
                          color: XCColors.mainTextColor,
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: detailEntity.isGroupProduct == 1
                                ? detailEntity.groupTotalPrice.toString()
                                : detailEntity.minPrice == 0
                                    ? detailEntity.product.price.toString()
                                    : detailEntity.minPrice
                                        .toString(),
                            style: TextStyle(
                              color: XCColors.mainTextColor,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Text(
                      '免费体验',
                      style: TextStyle(
                        color: XCColors.themeColor,
                        fontSize: 20,
                      ),
                    ),
              SizedBox(width: 5),
              Text(
                '￥${detailEntity.product.price}',
                style: TextStyle(
                  color: XCColors.goodsGrayColor,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: XCColors.goodsGrayColor,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          isBeanGoods
              ? Container()
              : isBean
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          _infoItem(isGrounding ? '技师' : '咨询师', '详情', 3),
                          SizedBox(width: 20),
                          _infoItem(isGrounding ? '门店' : '商家', '详情', 4),
                          SizedBox(width: 20),
                          _infoItem('颜值豆', '规则', 9)
                        ])
                  : detailEntity.product.isEnableFee == 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              _infoItem('套餐',
                                  comboResult.isEmpty ? '详情' : comboResult, 1),
                              SizedBox(width: 20),
                              _infoItem('分期', '详情', 2),
                              SizedBox(width: 20),
                              _infoItem(isGrounding ? '技师' : '咨询师', '详情', 3),
                              SizedBox(width: 20),
                              _infoItem(isGrounding ? '门店' : '商家', '详情', 4)
                            ])
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _infoOtherItem(isGrounding ? '技师' : '咨询师', '详情', 3),
                            SizedBox(width: 20),
                            _infoOtherItem(isGrounding ? '门店' : '商家', '详情', 4),
                            SizedBox(width: 20),
                            _infoCountItem()
                          ],
                        ),
          isBeanGoods ? Container() : SizedBox(height: 20),
          isBeanGoods
              ? Container()
              : Container(
                  height: 73,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
                  ]),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _iconItem('assets/images/home/home_detail_true.png',
                            '正品保障', 5),
                        _iconItem('assets/images/home/home_detail_member.png',
                            '会员专享', 6),
                        _iconItem('assets/images/home/home_detail_profit.png',
                            '分享返现', 7),
                        _iconItem(
                            'assets/images/home/home_detail_bao.png', '颜值保', 8)
                      ])),
          SizedBox(height: 12)
        ],
      ),
    );
  }

  static groupListWidget(
    BuildContext context,
    List<GroupItemEntity> list,
    bool isGrounding,
    Function() allAction,
    Function(GroupItemEntity item) tapAction,
  ) {
    Widget _buildItem(GroupItemEntity item) {
      return Container(
        height: 50,
        margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.white,
          border: Border.all(
            color: XCColors.themeColor,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(25),
                ),
              ),
              child: item.memberAvatar == ''
                  ? Image.asset('assets/images/mine/mine_avatar.png')
                  : CommonWidgets.networkImage(item.memberAvatar),
            ),
            SizedBox(width: 5),
            Text(
              item.memberNickName,
              style: TextStyle(
                fontSize: 12,
                color: XCColors.mainTextColor,
              ),
            ),
            Expanded(child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RichText(
                  text: TextSpan(
                    text: '还差',
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.tabSelectedColor,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.activityNumber - item.memberNum}',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.detailSelectedColor,
                        ),
                      ),
                      TextSpan(
                        text: '人成团',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabSelectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    text: '剩余',
                    style: TextStyle(
                      fontSize: 12,
                      color: XCColors.tabSelectedColor,
                    ),
                    children: [
                      TextSpan(
                        text: '${item.countdownTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.detailSelectedColor,
                        ),
                      ),
                      TextSpan(
                        text: '结束',
                        style: TextStyle(
                          fontSize: 12,
                          color: XCColors.tabSelectedColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 5),
            Container(
              width: 85,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
                color: XCColors.themeColor,
              ),
              child: Text(
                '去参团 >',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.only(top: 13, bottom: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                  child: Image.asset(
                      "assets/images/home/home_vip_icon_left.png",
                      width: 11,
                      height: 12)),
              Text(
                '不想开团，参加以下团购',
                style: TextStyle(
                  fontSize: 18,
                  color: XCColors.mainTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(child: Container()),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: allAction,
                child: Text(
                  '查看全部 >',
                  style:
                      TextStyle(fontSize: 12, color: XCColors.goodsGrayColor),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 60.0 * list.length,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => {tapAction(list[index])},
                  child: _buildItem(list[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  static detailPriceWidget(
    BuildContext context,
    ProductDetailEntity detailEntity,
    bool isGrounding,
  ) {
    ProjectPricesEntity entity = ProjectPricesEntity();
    entity.projectName = '项目名称';
    entity.projectComb = '项目组合';
    entity.doctor = '${isGrounding ? '技师' : '咨询师'}/级别';
    entity.isFirst = true;
    if (!detailEntity.productProjectPrices.first.isFirst) {
      detailEntity.productProjectPrices.insert(0, entity);
    }

    Widget _tableItem(String title, {bool isGrayColor = false}) {
      return Container(
        height: 28,
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
              color: isGrayColor
                  ? XCColors.tabNormalColor
                  : XCColors.mainTextColor,
              fontSize: 12),
        ),
      );
    }

    return Container(
        padding: const EdgeInsets.only(top: 13, bottom: 10),
        child: Column(children: [
          Row(children: [
            Container(
                width: 20,
                height: 20,
                padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                child: Image.asset("assets/images/home/home_vip_icon_left.png",
                    width: 11, height: 12)),
            Text('项目价格表',
                style: TextStyle(
                    fontSize: 18,
                    color: XCColors.mainTextColor,
                    fontWeight: FontWeight.bold))
          ]),
          SizedBox(height: 12),
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Table(
                  border: TableBorder.all(
                      color: XCColors.addressScreeningRightNormalColor,
                      width: 1),
                  children: detailEntity.productProjectPrices.map((e) {
                    return TableRow(children: [
                      _tableItem(e.projectName, isGrayColor: true),
                      _tableItem(e.projectComb, isGrayColor: true),
                      _tableItem(e.doctor, isGrayColor: true),
                      _tableItem(e.isFirst ? '雀斑价' : e.price.toString(),
                          isGrayColor: true)
                    ]);
                  }).toList()))
        ]));
  }

  static detailOtherPriceWidget(
      BuildContext context, ProductDetailEntity detailEntity) {
    Widget _tableItem(String title) {
      return Container(
        height: 28,
        alignment: Alignment.center,
        child: Text(title,
            style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12)),
      );
    }

    Widget _tableOtherItem(String title) {
      return Container(
        height: 28,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 27),
        child: Text(title,
            style: TextStyle(color: XCColors.mainTextColor, fontSize: 12)),
      );
    }

    /// 屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    double columnWidth = (screenWidth - 30) / 4.0;
    return Container(
      padding: const EdgeInsets.only(top: 13, bottom: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
                  child: Image.asset(
                      "assets/images/home/home_vip_icon_left.png",
                      width: 11,
                      height: 12)),
              Text('额外费用',
                  style: TextStyle(
                      fontSize: 18,
                      color: XCColors.mainTextColor,
                      fontWeight: FontWeight.bold))
            ]),
            Expanded(
              child: Text(
                '（此费用不包含在商品内)',
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 12,
                  color: XCColors.tabNormalColor,
                ),
              ),
            ),
            SizedBox(width: 15)
          ]),
          SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Table(
              //所有列宽
              columnWidths: {
                //列宽
                0: FixedColumnWidth(columnWidth),
                1: FixedColumnWidth(columnWidth * 3)
              },
              border: TableBorder.all(
                color: XCColors.homeDividerColor,
                width: 1,
              ),
              children: detailEntity.productAttributeVO.map((e) {
                return TableRow(children: [
                  _tableItem(e.name),
                  _tableOtherItem(e.productAttributeValueVOS.first.value)
                ]);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// ======  用户须知  =======
  static detailRuleWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(height: 1, color: XCColors.messageChatDividerColor),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 18, left: 17, right: 12, bottom: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('购买须知',
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 14)),
                    SizedBox(height: 10),
                    Text('「消费流程」',
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 12)),
                    SizedBox(height: 5),
                    Text(
                        '1.下订单并支付预约金;\n2.私信商家或咨询师咨询预约面诊;\n3.手术前将预约码给咨询师进行验证，并支付余下手术费用。',
                        style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 12,
                            height: 1.5))
                  ])),
          Container(height: 1, color: XCColors.messageChatDividerColor),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 15, left: 17, right: 12, bottom: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('「如何预约」',
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 12)),
                    SizedBox(height: 5),
                    Text('进入产品详情，点击立即购买，进入订单详情页，选择到店时间即可预约。',
                        style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 12,
                            height: 1.5))
                  ])),
          Container(height: 1, color: XCColors.messageChatDividerColor),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 15, left: 17, right: 12, bottom: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('「如何退款」',
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 12)),
                    SizedBox(height: 5),
                    Text(
                        '点击AP右下角的我的，进入“我的预约＂，点击进入订单详情页，点击“申请退款”，然后补充相关信息，3到5个工作日到达所填写账户。',
                        style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 12,
                            height: 1.5))
                  ])),
          Container(height: 1, color: XCColors.messageChatDividerColor),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.only(top: 15, left: 17, right: 12, bottom: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('「消费须知」',
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 12)),
                SizedBox(height: 5),
                Text(
                    '1.下单后，点击产品图下方“咨询师头像＂＝＞进入“咨询师主页”＝＞点击“私信”，直接咨询咨询师，进行预约。\n2.请在确定手术后，再将验证码交给咨询师。验证码交给咨询师后，视为已经手术，您将无法退款。\n3.该商品支付成功后，预约码至支付之日起一个月内有效请尽快到店使用。\n4.下单后，您到商家还需缴纳(新氧价-预约金)元，请您下单时备注购买的具体项目内容。\n5.若您还有其他疑问，请在工作日的09:00-18:00联系雀斑',
                    style: TextStyle(
                        color: XCColors.tabNormalColor,
                        fontSize: 12,
                        height: 1.5))
              ],
            ),
          ),
          SizedBox(height: 110)
        ],
      ),
    );
  }

  static detailCart(
    BuildContext context,
    int cartNumber,
    DetailComboEntity selectedCombo,
    ProductDetailEntity productDetail,
    final VoidCallback tipTap,
    tapAction,
  ) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              height: 30,
              color: XCColors.detailRuleTipBgColor,
              child: Row(children: [
                GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: tipTap,
                    child: Row(children: [
                      Container(
                          width: 14,
                          height: 14,
                          child: Image.asset(
                              'assets/images/home/home_detail_tip.png',
                              fit: BoxFit.cover)),
                      SizedBox(width: 5, height: 30),
                      Text('预约金：',
                          style: TextStyle(color: Colors.black, fontSize: 11))
                    ])),
                RichText(
                    text: TextSpan(
                        text: '¥',
                        style: TextStyle(
                            color: XCColors.bannerSelectedColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                        children: [
                      TextSpan(
                          text: selectedCombo.subscribePrice.toString(),
                          style: TextStyle(
                              color: XCColors.bannerSelectedColor,
                              fontSize: 16))
                    ])),
                SizedBox(width: 14),
                Text('到店再付：¥${selectedCombo.finalPrice.toString()}',
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 11))
              ])),
          Container(
            height: 50,
            padding: const EdgeInsets.only(right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        tapAction(1);
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/home/home_detail_service.png',
                              width: 18,
                              height: 18,
                              color: Colors.black,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '咨询',
                              style: TextStyle(
                                fontSize: 11,
                                color: XCColors.mainTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            tapAction(2);
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/home/home_detail_cart.png',
                                  width: 20,
                                  height: 18,
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '购物车',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: XCColors.mainTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 6,
                          child: Offstage(
                            offstage: cartNumber == 0,
                            child: Container(
                              width: 12,
                              height: 12,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: XCColors.themeColor,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Text(
                                cartNumber.toString(),
                                style: TextStyle(
                                  fontSize: 8,
                                  color: XCColors.themeColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        tapAction(3);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: XCColors.themeColor),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          productDetail.isGroupProduct == 1 ? '单独购买' : '加入购物车',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: XCColors.themeColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 13),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        tapAction(4);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 90,
                        height: 30,
                        decoration: BoxDecoration(
                          color: XCColors.themeColor,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          productDetail.isGroupProduct == 1 ? '立即开团' : '立即购买',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
    );
  }

  static detailBeanCart(BuildContext context, tapAction) {
    return Container(
        color: Colors.white,
        height: 50,
        padding: const EdgeInsets.only(right: 15),
        child: Row(children: [
          Row(children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapAction(1);
              },
              child: Container(
                width: 50,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/tabs/home_selected.png',
                        width: 20, height: 18),
                    SizedBox(height: 4),
                    Text(
                      '首页',
                      style: TextStyle(
                        fontSize: 11,
                        color: XCColors.mainTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  tapAction(2);
                },
                child: Container(
                    width: 50,
                    height: 50,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/home/home_detail_cart.png',
                              width: 20, height: 18),
                          SizedBox(height: 4),
                          Text('咨询',
                              style: TextStyle(
                                  fontSize: 11, color: XCColors.mainTextColor))
                        ])))
          ]),
          SizedBox(width: 13),
          Expanded(
              child: Text('15000豆',
                  textAlign: TextAlign.end,
                  style:
                      TextStyle(fontSize: 16, color: XCColors.mainTextColor))),
          SizedBox(width: 13),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                tapAction(3);
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 90,
                  height: 30,
                  decoration: BoxDecoration(
                      color: XCColors.themeColor,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Text('立即兑换',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white))))
        ]));
  }

  static commentHeaderView(BuildContext context, CommentInfoEntity entity,
      List<HomeDistanceEntity> tabEntityList, tapAction) {
    return Container(
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(height: 1, color: XCColors.homeDividerColor),
        SizedBox(height: 13),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            children: [
              Text(
                entity.productScore.totalScore.toString(),
                style: TextStyle(
                  color: XCColors.mainTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              CommonWidgets.scoreWidget(
                int.parse(
                  entity.productScore.totalScore.toString().split('.').first,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 3, bottom: 15),
          child: Row(children: [
            Text('环境：${entity.productScore.envScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 20),
            Text('专业度：${entity.productScore.majorScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 20),
            Text('服务：${entity.productScore.serveScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 20),
            Expanded(
                child: Text('效果：${entity.productScore.resultScore}',
                    style: TextStyle(
                        fontSize: 12, color: XCColors.tabNormalColor))),
          ]),
        ),
        Container(height: 1, color: XCColors.homeDividerColor),
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 5),
          child: Wrap(
            spacing: 15,
            runSpacing: 15,
            alignment: WrapAlignment.start,
            children: List.generate(
              tabEntityList.length,
              (index) {
                HomeDistanceEntity entity = tabEntityList[index];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    tapAction(index);
                  },
                  child: Container(
                    height: 25,
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 4),
                    decoration: BoxDecoration(
                      color: entity.isSelected
                          ? XCColors.bannerSelectedColor
                          : XCColors.bannerHintColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12.5),
                      ),
                    ),
                    child: Text(
                      entity.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: entity.isSelected
                            ? Colors.white
                            : XCColors.mainTextColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          height: 30,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/home/home_detail_arrow_down.png',
            width: 14,
            height: 7,
          ),
        ),
        Container(height: 1, color: XCColors.homeDividerColor),
      ]),
    );
  }

  static commentItem(BuildContext context, CommentItemEntity itemEntity) {
    Widget _item(
        String title, String image, double imageWidth, double imageHeight) {
      return Row(
        children: [
          Image.asset(image, width: imageWidth, height: imageHeight),
          SizedBox(width: 3),
          Text(title,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
        ],
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: CommonWidgets.networkImage(itemEntity.memberIcon)),
          SizedBox(width: 6),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(itemEntity.memberNickName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 14)),
                SizedBox(height: 10),
                CommonWidgets.scoreWidget(itemEntity.totalScore)
              ])),
          SizedBox(width: 10),
          Text(itemEntity.createTime,
              style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 12))
        ]),
        Container(
          padding:
              const EdgeInsets.only(left: 47, right: 15, top: 10, bottom: 10),
          child: Row(children: [
            Text('环境：${itemEntity.envScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 10),
            Text('专业度：${itemEntity.majorScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 10),
            Text('服务：${itemEntity.serveScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 10),
            Expanded(
                child: Text('效果：${itemEntity.resultScore}',
                    style: TextStyle(
                        fontSize: 12, color: XCColors.tabNormalColor))),
          ]),
        ),
        Container(
            padding: const EdgeInsets.only(left: 47, right: 15, bottom: 10),
            child: Text(itemEntity.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: XCColors.mainTextColor))),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          _item('${itemEntity.readCount}',
              'assets/images/home/home_detail_diary_reading.png', 16, 9),
          SizedBox(width: 15),
          _item(
              '${itemEntity.praiseCount}',
              itemEntity.praiseFlag == 0
                  ? 'assets/images/home/home_detail_diary_like_normal.png'
                  : 'assets/images/home/home_detail_diary_like_selected.png',
              17,
              17),
          SizedBox(width: 15),
          _item('${itemEntity.replayCount}',
              'assets/images/home/home_detail_diary_comment.png', 12, 12)
        ]),
        SizedBox(height: 15)
      ]),
    );
  }

  static commentWithImageItem(
      BuildContext context, CommentItemEntity itemEntity) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = (screenWidth - 97) / 3.0;
    List<String> images = itemEntity.pics.split(',');

    Widget _item(
        String title, String image, double imageWidth, double imageHeight) {
      return Row(
        children: [
          Image.asset(image, width: imageWidth, height: imageHeight),
          SizedBox(width: 3),
          Text(title,
              style: TextStyle(color: XCColors.tabNormalColor, fontSize: 12))
        ],
      );
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
              width: 40,
              height: 40,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: CommonWidgets.networkImage(itemEntity.memberIcon)),
          SizedBox(width: 6),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(itemEntity.memberNickName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(color: XCColors.mainTextColor, fontSize: 14)),
                SizedBox(height: 10),
                CommonWidgets.scoreWidget(itemEntity.totalScore)
              ])),
          SizedBox(width: 10),
          Text(itemEntity.createTime,
              style: TextStyle(color: XCColors.goodsGrayColor, fontSize: 12))
        ]),
        Container(
          padding:
              const EdgeInsets.only(left: 47, right: 15, top: 10, bottom: 10),
          child: Row(children: [
            Text('环境：${itemEntity.envScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 10),
            Text('专业度：${itemEntity.majorScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 10),
            Text('服务：${itemEntity.serveScore}',
                style: TextStyle(fontSize: 12, color: XCColors.tabNormalColor)),
            SizedBox(width: 10),
            Expanded(
                child: Text('效果：${itemEntity.resultScore}',
                    style: TextStyle(
                        fontSize: 12, color: XCColors.tabNormalColor))),
          ]),
        ),
        Container(
            padding: const EdgeInsets.only(left: 47, right: 15, bottom: 10),
            child: Text(itemEntity.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, color: XCColors.mainTextColor))),
        Container(
            padding: const EdgeInsets.only(left: 47, bottom: 8),
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
                      return Container(
                          height: imageWidth,
                          width: imageWidth,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: CommonWidgets.networkImage(images[index]));
                    }))),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          _item('${itemEntity.readCount}',
              'assets/images/home/home_detail_diary_reading.png', 16, 9),
          SizedBox(width: 15),
          _item(
              '${itemEntity.praiseCount}',
              itemEntity.praiseFlag == 0
                  ? 'assets/images/home/home_detail_diary_like_normal.png'
                  : 'assets/images/home/home_detail_diary_like_selected.png',
              17,
              17),
          SizedBox(width: 15),
          _item('${itemEntity.replayCount}',
              'assets/images/home/home_detail_diary_comment.png', 12, 12)
        ]),
        SizedBox(height: 15)
      ]),
    );
  }
}
