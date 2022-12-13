import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_medical_beauty/colors.dart';
import 'package:flutter_medical_beauty/tool.dart';
import 'package:flutter_medical_beauty/ui/home/detail/detail.dart';
import 'package:flutter_medical_beauty/ui/home/detail/order/entity.dart';
import 'package:flutter_medical_beauty/ui/home/entity.dart';
import 'package:flutter_medical_beauty/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../navigator.dart';

abstract class OrderWidgets {
  static orderInfo(BuildContext context, String selectedDate,
      DetailOrderEntity orderEntity, final VoidCallback onTimeTap) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
        child: Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: CommonWidgets.networkImage(orderEntity.pic)),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(orderEntity.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 14)),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            '¥${orderEntity.isAllPay == 1 ? orderEntity.allPayAmount : orderEntity.subscribePrice}',
                            style: TextStyle(
                                color: XCColors.themeColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,),),
                        SizedBox(width: 5),
                        Text(
                          'x1',
                          style: TextStyle(
                            color: XCColors.goodsGrayColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTimeTap,
              child: Container(
                  height: 38,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('预约到店时间：',
                            style: TextStyle(
                                color: XCColors.mainTextColor, fontSize: 12)),
                        SizedBox(width: 5),
                        Expanded(
                            child: Text(selectedDate,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: XCColors.tabNormalColor,
                                    fontSize: 12))),
                        SizedBox(width: 5),
                        CommonWidgets.grayRightArrow()
                      ])))
        ]));
  }

  static orderTipInfo(BuildContext context, String title, String value) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: XCColors.mainTextColor,
              fontSize: 12,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: XCColors.mainTextColor,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///TODO 颜值保隐藏处理
  static orderInsuranceInfo(
      BuildContext context,
      bool isBuy,
      DetailOrderEntity orderEntity,
      String insuranceObjectName,
      final VoidCallback onTap,
      final VoidCallback pushTap) {
    return Column(
      children: [
        Container(
          height: 0,
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
          child: Row(
            children: [
              Image.asset('assets/images/home/home_detail_order_insurance.png',
                  height: 20, width: 62),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  '支付${orderEntity.guaranteeAmount}，最高赔付${orderEntity.compensateAmount}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: XCColors.bannerSelectedColor,
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(width: 5),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Image.asset(
                  isBuy
                      ? 'assets/images/home/home_detail_order_insurance_on.png'
                      : 'assets/images/home/home_detail_order_insurance_off.png',
                  height: 28,
                  width: 52,
                ),
              ),
            ],
          ),
        ),
        Offstage(
          offstage: !isBuy,
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: pushTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 38,
                  child: Row(
                    children: [
                      Text('被保人：$insuranceObjectName',
                          style: TextStyle(
                              color: XCColors.tabNormalColor, fontSize: 11)),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          '修改资料',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: XCColors.tabNormalColor,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      CommonWidgets.grayRightArrow()
                    ],
                  ),
                ),
              ),
              OrderWidgets.orderTipInfo(
                context,
                '颜值保小计：',
                '¥${orderEntity.guaranteeAmount}',
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///TODO 会员自购折扣隐藏
  static orderMemberInfo(BuildContext context) {
    return Column(children: [
      Container(
          height: 0,
          color: Colors.white,
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 12, bottom: 12),
          child: Row(children: [
            Expanded(
                child: Text('黄金会员自购下单支付尾款立减：',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: XCColors.mainTextColor, fontSize: 12))),
            SizedBox(width: 5),
            Text('￥500',
                style: TextStyle(
                    color: XCColors.bannerSelectedColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold))
          ])),
      Container(
          height: 0,
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 3),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('黄金会员自购立减  5%',
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 11)),
            SizedBox(height: 3),
            Text('铂金会员自购立减  8%',
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 11)),
            SizedBox(height: 3),
            Text('钻石会员自购立减  10%',
                style: TextStyle(color: XCColors.tabNormalColor, fontSize: 11))
          ]))
    ]);
  }

  /// 颜值金
  static orderExchangeInfo(BuildContext context, bool isExchange,
      DetailOrderEntity orderEntity, final VoidCallback onTap) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '共${orderEntity.beautyBalance}颜值金，可使用颜值金折扣',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: XCColors.mainTextColor, fontSize: 12),
            ),
          ),
          SizedBox(width: 5),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Image.asset(
                isExchange
                    ? 'assets/images/home/home_detail_order_insurance_on.png'
                    : 'assets/images/home/home_detail_order_insurance_off.png',
                height: 28,
                width: 52),
          ),
        ],
      ),
    );
  }

  ///TODO 隐藏下单好友邀请码
  static orderEditInfo(
      BuildContext context, TextEditingController textEditingController) {
    return Container(
      height: 0,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      child: Row(
        children: [
          Text('好友邀请码',
              style: TextStyle(
                  color: XCColors.mainTextColor, height: 2.5, fontSize: 12)),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              height: 40,
              child: TextField(
                controller: textEditingController,
                style: TextStyle(fontSize: 12, color: XCColors.mainTextColor),
                maxLines: 1,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: '输入好友邀请码',
                  hintStyle:
                      TextStyle(fontSize: 12, color: XCColors.tabNormalColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static orderBottomTool(BuildContext context, bool isBuy,
      DetailOrderEntity orderEntity, final VoidCallback onTap) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
            child: orderEntity.isAllPay == 1
                ? Text(
                    '需支付：${orderEntity.allPayAmount + (isBuy ? orderEntity.guaranteeAmount : 0)}元')
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(children: [
                        Text(
                          isBuy ? '预约金+颜值保：' : '预约金',
                          style: TextStyle(
                            color: XCColors.mainTextColor,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          isBuy
                              ? '¥${orderEntity.subscribePrice + orderEntity.guaranteeAmount}'
                              : '¥${orderEntity.subscribePrice}',
                          style: TextStyle(
                            color: XCColors.themeColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                      Text(
                        '到店再付：¥${orderEntity.finalPrice}',
                        style: TextStyle(
                          color: XCColors.tabNormalColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: 100,
              height: double.infinity,
              color: XCColors.themeColor,
              alignment: Alignment.center,
              child: Text(
                '确认订单',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static orderFreeInfo(BuildContext context, String selectedDate,
      DetailOrderEntity orderEntity, final VoidCallback onTimeTap) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                  width: 80,
                  height: 80,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: CommonWidgets.networkImage(orderEntity.pic)),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 30,
                      child: Text(
                        orderEntity.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '¥${orderEntity.totalPrice}',
                          style: TextStyle(
                              color: XCColors.bannerSelectedColor,
                              fontSize: 14,
                              decoration: TextDecoration.lineThrough,),
                        ),
                        Expanded(
                          child: Text(
                            '免费体验',
                            style: TextStyle(
                              color: XCColors.bannerSelectedColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'x1',
                          style: TextStyle(
                              color: XCColors.goodsGrayColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTimeTap,
            child: Container(
              height: 38,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('预约到店时间：',
                      style: TextStyle(
                          color: XCColors.mainTextColor, fontSize: 12)),
                  SizedBox(width: 5),
                  Expanded(
                      child: Text(selectedDate,
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: XCColors.tabNormalColor, fontSize: 12))),
                  SizedBox(width: 5),
                  CommonWidgets.grayRightArrow()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static orderFreeBottomTool(BuildContext context, final VoidCallback onTap) {
    return Container(
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        children: [
          Expanded(
              child: Row(children: [
            Text('实付：',
                style: TextStyle(color: XCColors.mainTextColor, fontSize: 16)),
            Text('¥0',
                style: TextStyle(
                    color: XCColors.themeColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,),),
          ],),),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onTap,
            child: Container(
              width: 100,
              height: double.infinity,
              color: XCColors.themeColor,
              alignment: Alignment.center,
              child: Text(
                '确认订单',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static insuranceInfo(BuildContext context, final VoidCallback onTap) {
    Widget insuranceItem(String title, String content) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 85,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: XCColors.tabNormalColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              content,
              style: TextStyle(
                fontSize: 12,
                color: XCColors.mainTextColor,
              ),
            ),
          ),
        ],
      );
    }

    return Container(
        color: Colors.white,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 10),
        child: Column(children: [
          insuranceItem('保险期限：',
              '验证订单后，眼部项目、鼻部项目、胸部整形项目、美体塑形项目、面部轮廓项目180天内申请理赔，剩余项目90天内申请理赔'),
          SizedBox(height: 10),
          insuranceItem('被保人要求：', '被保人要求:限18～50岁周岁具有完全行为能力的中国公民(不含港澳台)'),
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Container(
                  height: 30,
                  child: Row(children: [
                    Image.asset(
                        'assets/images/home/home_detail_order_insurance.png',
                        height: 20,
                        width: 62),
                    SizedBox(width: 10),
                    Expanded(
                        child: Text('什么是颜值保',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: XCColors.bannerSelectedColor,
                                fontSize: 12))),
                    SizedBox(width: 5),
                    CommonWidgets.grayRightArrow()
                  ])))
        ]));
  }

  static insurancePriceInfo(BuildContext context, String price) {
    return Container(
        height: 40,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(children: [
          Container(
              width: 85,
              child: Text('颜值保价格',
                  style:
                      TextStyle(fontSize: 13, color: XCColors.tabNormalColor))),
          Expanded(
              child: Text('¥$price',
                  style:
                      TextStyle(fontSize: 13, color: XCColors.goodsGrayColor)))
        ]));
  }

  static insuranceEditInfo(BuildContext context, String title, String hint,
      TextEditingController textEditingController) {
    return Container(
        height: 40,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(children: [
          Container(
              width: 85,
              child: Text(title,
                  style:
                      TextStyle(fontSize: 13, color: XCColors.tabNormalColor))),
          Expanded(
              child: Container(
                  height: 40,
                  child: TextField(
                      controller: textEditingController,
                      style: TextStyle(
                          fontSize: 12, color: XCColors.tabNormalColor),
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: hint,
                          hintStyle: TextStyle(
                              fontSize: 13, color: XCColors.goodsGrayColor)))))
        ]));
  }

  static insuranceAgreeInfo(BuildContext context, bool isAgree,
      final VoidCallback onAgreeTap, final VoidCallback onTap) {
    return Container(
        height: 42,
        color: Colors.white,
        padding: const EdgeInsets.only(left: 5, right: 10),
        child: Row(children: [
          GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onAgreeTap,
              child: Container(
                  width: 34,
                  height: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(
                      isAgree
                          ? 'assets/images/box/box_check_selected.png'
                          : 'assets/images/box/box_check_normal.png',
                      width: 14,
                      height: 14))),
          SizedBox(width: 5),
          Expanded(
              child: RichText(
                  text: TextSpan(
                      text: '已阅读并同意《',
                      style: TextStyle(
                          fontSize: 13, color: XCColors.tabNormalColor),
                      children: [
                TextSpan(
                    text: '投保协议',
                    style: TextStyle(
                        fontSize: 13, color: XCColors.bannerSelectedColor),
                    recognizer: TapGestureRecognizer()..onTap = onTap),
                TextSpan(
                    text: '》',
                    style:
                        TextStyle(fontSize: 13, color: XCColors.tabNormalColor))
              ])))
        ]));
  }

  static paySuccessView(BuildContext context, final VoidCallback backHome,
      final VoidCallback onTap) {
    return Container(
        color: Colors.white,
        padding:
            const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 22),
        child: Column(children: [
          Container(
              width: 264,
              height: 177,
              child: Image.asset(
                  'assets/images/home/home_detail_pay_success.png',
                  fit: BoxFit.cover)),
          SizedBox(height: 20),
          Text('支付成功！',
              style: TextStyle(
                  fontSize: 14,
                  color: XCColors.bannerSelectedColor,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: backHome,
                child: Container(
                    width: 110,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: XCColors.homeDividerColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text('返回首页',
                        style: TextStyle(
                            color: XCColors.mainTextColor, fontSize: 16)))),
            SizedBox(width: 50),
            GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Container(
                    width: 110,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: XCColors.themeColor,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text('查看订单',
                        style: TextStyle(color: Colors.white, fontSize: 16)))),
          ])
        ]));
  }

  static payTipWidget(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(children: [
            SizedBox(height: 5),
            Image.asset(
              "assets/images/home/home_vip_icon_left.png",
              width: 11,
              height: 12,
              color: XCColors.themeColor,
            )
          ]),
          Text(
            '猜你喜欢',
            style: TextStyle(fontSize: 20, color: XCColors.detailSelectedColor),
          ),
          Column(
            children: [
              SizedBox(height: 20),
              Image.asset(
                "assets/images/home/home_vip_icon_right.png",
                width: 11,
                height: 12,
                color: XCColors.themeColor,
              )
            ],
          ),
        ],
      ),
    );
  }

  static payFailureView(BuildContext context, final VoidCallback backHome,
      final VoidCallback onTap) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 22),
      child: Column(
        children: [
          Container(
              width: 264,
              height: 177,
              child: Image.asset(
                  'assets/images/home/home_detail_pay_failure.png',
                  fit: BoxFit.cover)),
          SizedBox(height: 20),
          Text('支付失败！',
              style: TextStyle(
                  fontSize: 14,
                  color: XCColors.bannerSelectedColor,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: backHome,
                  child: Container(
                      width: 110,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: XCColors.homeDividerColor,
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Text('取消订单',
                          style: TextStyle(
                              color: XCColors.mainTextColor, fontSize: 16)))),
              SizedBox(width: 50),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap,
                child: Container(
                  width: 110,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XCColors.themeColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    '重新支付',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static orderBodyWidget(BuildContext context, List<ProductItemEntity> list,
      {bool? hasBottom}) {
    return Container(
      margin: EdgeInsets.only(bottom: hasBottom ?? false ? 42 : 0),
      child: StaggeredGridView.countBuilder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
          crossAxisCount: 4,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  NavigatorUtil.pushPage(context, DetailScreen(list[index].id));
                },
                child: goodsTile(context, list[index]),
              ),
          staggeredTileBuilder: (int index) => StaggeredTile.fit(2),
          mainAxisSpacing: 6.0,
          crossAxisSpacing: 10.0),
    );
  }

  static goodsTile(BuildContext context, ProductItemEntity itemEntity) {
    /// 标签视图
    Widget _flagItem(String image, String title) {
      return Container(
          width: 16,
          height: 18,
          child: Stack(children: [
            Image.asset(image, width: 16, height: 18),
            Center(
                child: Text(title,
                    style: TextStyle(fontSize: 10, color: Colors.white)))
          ]));
    }

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(color: XCColors.categoryGoodsShadowColor, blurRadius: 5)
          ],
          color: Colors.white),
      child: Column(
        children: [
          Container(
              height: 164, child: CommonWidgets.networkImage(itemEntity.pic)),
          Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 5, top: 8, right: 5, bottom: 5),
              child: Text(itemEntity.name,
                  style: TextStyle(color: XCColors.mainTextColor, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
          Offstage(
              offstage: itemEntity.isEnableFee != 1,
              child: Container(
                  padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                  child: Row(children: [
                    _flagItem(
                        'assets/images/home/home_goods_flag_orange.png', '惠')
                  ]))),
          Container(
            height: 25,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¥${itemEntity.price}',
                  style: TextStyle(
                    fontSize: 18,
                    color: XCColors.themeColor,
                  ),
                ),
                Offstage(
                  offstage: itemEntity.isEnableFee != 1,
                  child: Container(
                    height: 20,
                    width: 65,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: XCColors.themeColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      '免费体验',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${itemEntity.reserveNum}人已预约',
                    style: TextStyle(
                      fontSize: 11,
                      color: XCColors.goodsGrayColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    itemEntity.orgName,
                    style: TextStyle(
                      fontSize: 10,
                      color: XCColors.goodsOtherGrayColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  itemEntity.distance.isEmpty
                      ? '0km'
                      : '${Tool.formatNum(double.parse(itemEntity.distance), 0)}km',
                  style: TextStyle(
                      fontSize: 10, color: XCColors.goodsOtherGrayColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
